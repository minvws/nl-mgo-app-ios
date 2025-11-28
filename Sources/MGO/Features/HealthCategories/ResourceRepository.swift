/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

protocol ResourceRepositoryProtocol {
	
	/// Load all the categories for all the stored healthcare organizations
	@MainActor func load()
	
	/// Load all the categories for a healthcare organization
	/// - Parameter healthcareOrganization: the healthcare organization to load all the categories for
	@MainActor func loadFor(_ healthcareOrganization: MgoOrganization)
	
	/// Load all the categories for a category
	/// - Parameter category: the category to load  for
	@MainActor func loadFor(_ category: SharedHealthCategories.Category)
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - category: the category to load the resources for.
	@MainActor func loadResource(
		_ healthcareOrganization: MgoOrganization,
		category: SharedHealthCategories.Category
	)
	
	/// Load a binary object
	/// - Parameters:
	///   - healthcareOrganization: the healthcare organization
	///   - serviceId: the service id
	///   - url: the url of the binary
	/// - Returns: Optional Binary
	@MainActor func loadBinary(
		_ healthcareOrganization: MgoOrganization,
		serviceId: String,
		path: String
	) async throws -> FHIRBinary?
	
	/// Get the version of the shared library
	/// - Returns: the shared version
	@MainActor func getVersion() throws -> SharedVersion
}

/// Load the resources from the server
class ResourceRepository: ResourceRepositoryProtocol {
	
	typealias Solution = (
		endpoint: DataServices.Endpoint,
		fhirVersion: DataServices.FhirVersion,
		dvaTarget: String,
		dataServiceId: String,
		providerId: String?
	)
	
	typealias MappedSolution = (
		endpoint: DataServices.Endpoint,
		categories: [SharedHealthCategories.Category],
		fhirVersion: DataServices.FhirVersion,
		dvaTarget: String,
		dataServiceId: String,
		providerId: String?
	)
	
	/// Token for the observatory (needed for unregister)
	private var observerToken: Observatory.ObserverToken?
	
	/// Local version of the healthcare organization store
	private var healthcareOrganizationRepository: HealthcareOrganizationRepositoryProtocol?
	
	/// Local version of the data repository
	private var dataRepository: MgoDataStoreProtocol?
	
	/// Local version of the feature flag manager
	private var featureFlagManager: FeatureFlagManaging?
	
	/// the authentication username
	private var username: String?
	
	/// The authentication password
	private var password: String?
	
	/// The MGO repository to fetch FHIR objects
	private var repository: MGORepository
	
	/// Create the Resource Repository
	/// - Parameters:
	///   - healthcareOrganizationRepository: the repository for healthcare organizations
	///   - dataRepository: the repository for data storage
	///   - serverUrl: the url of the server
	///   - username: the authentication username
	///   - password: the authentication password
	@MainActor init(
		healthcareOrganizationRepository: HealthcareOrganizationRepositoryProtocol,
		dataRepository: MgoDataStoreProtocol,
		featureFlagManager: FeatureFlagManaging,
		serverUrl: Foundation.URL,
		username: String?,
		password: String?) {
		
		self.healthcareOrganizationRepository = healthcareOrganizationRepository
		self.dataRepository = dataRepository
		self.featureFlagManager = featureFlagManager
		self.repository = MGORepository(client: FHIRClient(baseURL: serverUrl))
		self.username = username
		self.password = password
		registerObservers()
	}
	
	/// Listen to changes in the stored organizations list
	@MainActor private func registerObservers() {
		
		self.observerToken = healthcareOrganizationRepository?.observatory.append { [weak self] organization, reason in
			Task { @MainActor in
				self?.handleOrganizationChanges(organization, reason: reason)
			}
		}
	}
	
	/// Get the version of the shared library
	/// - Returns: the shared version
	@MainActor func getVersion() throws -> SharedVersion {
		return try repository.getVersion()
	}
	
	/// Handle changes in the organizations list
	/// - Parameters:
	///   - organization: optional organization added or removed
	///   - reason: the reason the list has changed
	@MainActor func handleOrganizationChanges(
		_ organization: MgoOrganization?,
		reason: HealthcareOrganizationReason
	) {
		switch reason {
			case .added:
				if let organization {
					// New organization, load the data
					logVerbose("ResourceRepository observatory .added triggered for  \(organization.display_name)")
					loadFor(organization)
				}
			
			case .removed:
				if let organization {
					// Remove stored data for the removed organization
					logVerbose("ResourceRepository observatory .removed for \(organization.display_name)")
					dataRepository?.removeRecords(for: organization.identifier)
				}
			
			case .changed:
				logVerbose("ResourceRepository observatory .changed")
				dataRepository?.removeAllRecords()
				load()
		}
	}
	
	deinit {
		// Remove as observer
		if let healthcareOrganizationRepository {
			observerToken.map(healthcareOrganizationRepository.observatory.remove)
		}
	}
	
	/// Load all the categories for a healthcare organization
	/// - Parameter healthcareOrganization: the healthcare organization to load all the categories for
	@MainActor func loadFor(_ healthcareOrganization: MgoOrganization) {
		
		logVerbose("ResourceRepository - LoadFor Org", healthcareOrganization.identifier)
		guard let sharedCategories = try? SharedHealthCategories() else { return }
		
		var mappings: [String: MappedSolution] = [:]
		for sharedCategory in sharedCategories.mainCategories.flatMap({ $0.categories }) {
			for solution in collectEndpoints(healthcareOrganization, category: sharedCategory) {
				let key = solution.endpoint.id + solution.dataServiceId
				if mappings[key] != nil {
					mappings[key]?.categories.append(sharedCategory)
				} else {
					mappings[key] = MappedSolution(
						endpoint: solution.endpoint,
						categories: [sharedCategory],
						fhirVersion: solution.fhirVersion,
						dvaTarget: solution.dvaTarget,
						dataServiceId: solution.dataServiceId,
						providerId: solution.providerId
					)
				}
			}
		}
		loadEndpoints(healthcareOrganization, mappings: mappings)
	}
	
	/// Load all the categories for a category
	/// - Parameter category: the category to load  for
	@MainActor func loadFor(_ category: SharedHealthCategories.Category) {
		logVerbose("ResourceRepository - LoadFor Cat", category)
		
		guard let healthcareOrganizationRepository else { return }
		
		for healthcareOrganization in healthcareOrganizationRepository.organizations {
			loadResource(healthcareOrganization, category: category)
		}
	}
	
	/// Load all the categories for all the stored healthcare organizations
	@MainActor func load() {
		
		guard let healthcareOrganizationRepository else { return }
		for healthcareOrganization in healthcareOrganizationRepository.organizations {
			loadFor(healthcareOrganization)
		}
	}
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - category: the category to load the resources for.
	@MainActor func loadResource(
		_ healthcareOrganization: MgoOrganization,
		category: SharedHealthCategories.Category
	) {
		
		logVerbose("ResourceRepository - LoadFor Org and Cat", healthcareOrganization.identifier, category.id)
		var mappings: [String: MappedSolution] = [:]
		for solution in collectEndpoints(healthcareOrganization, category: category) {
			let key = solution.endpoint.id + solution.dataServiceId
			if mappings[key] != nil {
				mappings[key]?.categories.append(category)
			} else {
				mappings[key] = MappedSolution(
					endpoint: solution.endpoint,
					categories: [category],
					fhirVersion: solution.fhirVersion,
					dvaTarget: solution.dvaTarget,
					dataServiceId: solution.dataServiceId,
					providerId: solution.providerId
				)
			}
		}
		loadEndpoints(healthcareOrganization, mappings: mappings)
	}
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - mappings: the mapped solutions
	@MainActor private func loadEndpoints(
		_ healthcareOrganization: MgoOrganization,
		mappings: [String: MappedSolution]
	) {
		for (_, mappedSolution) in mappings {
			_Concurrency.Task(priority: .high) {
				await loadEndpoint(healthcareOrganization, mapping: mappedSolution)
			}
		}
	}
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - mapping: the mapped solution
	@MainActor func loadEndpoint(
		_ healthcareOrganization: MgoOrganization,
		mapping: MappedSolution
	) async {
		
		var mgoResources = [MgoResource]()
		var resourceError = false
		
		do {
			logVerbose("ResourceRepository - calling endpoint for \(mapping.dvaTarget)", mapping.endpoint)
			let fhirBundle = try await repository.getBundleData(
				endpoint: mapping.endpoint,
				fhirVersion: mapping.fhirVersion,
				headers: MGORepositoryHeaders(
					dvaTarget: mapping.dvaTarget,
					dataServiceId: mapping.dataServiceId,
					medmijId: mapping.providerId,
					username: username,
					password: password
				)
			)
			
			mgoResources = try await repository.process(
				fhirBundle,
				fhirVersion: mapping.fhirVersion.rawValue
			)
		} catch {
			logError("ResourceRepository", error)
			resourceError = true
		}
		
		for category in mapping.categories {
			
			let recordToStore = MgoResourceRecord(
				categoryId: category.id,
				organizationId: healthcareOrganization.identifier,
				resources: mgoResources,
				error: resourceError
			)
			logVerbose("ResourceRepository - Adding to the store", recordToStore)
			
			let delayInSeconds: Double = (featureFlagManager?.isDemo ?? false) ? 5 : 0
			delay(delayInSeconds) {
				self.dataRepository?.store(data: recordToStore)
			}
		}
	}
	
	/// Get a collection of usable endpoints for a healthcare organization and a category
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - category: the category to load the resources for.
	@MainActor func collectEndpoints(
		_ healthcareOrganization: MgoOrganization,
		category: SharedHealthCategories.Category
	) -> [Solution] {
		
		logVerbose("\n\n collectEndpoints for category:", category.id)
		var results = [(DataServices.Endpoint, DataServices.FhirVersion, String, String, String?)]()
		for dataService in DataServices(isDemo: Container.shared.featureFlagManager().isDemo).services {
			
			// Check if the organization uses this data service
			guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: dataService.id) else {
				logVerbose("No dvaTarget for", dataService.id, healthcareOrganization.identifier, category.heading)
				continue
			}
			
			for endpoint in getUsableEndpoints(for: dataService, category: category) {
				results.append(
					(
						endpoint: endpoint,
						fhirVersion: dataService.fhirVersionEnum,
						dvaTarget: dvaTarget,
						dataServiceId: dataService.id,
						providerId: healthcareOrganization.medmij_id
					)
				)
			}
		}
		return results
	}
	
	/// Which endpoints should we use
	/// - Parameters:
	///   - dataService: the data service
	///   - category: the category
	/// - Returns: all the endpoints that have the same profile from the data service and the sub categories
	func getUsableEndpoints(
		for dataService: DataServices.DataService,
		category: SharedHealthCategories.Category
	) -> Set<DataServices.Endpoint> {
		
		// Set of endpoints to use. a set to filter duplicates
		var usableEndpoints = Set<DataServices.Endpoint>()
		for endpoint in dataService.endpoints {
			for dsProfile in endpoint.profiles {
				for scProfile in category.profiles() where scProfile == dsProfile {
					usableEndpoints.insert(endpoint)
				}
			}
		}
		logVerbose("Usable endpoints", usableEndpoints)
		return usableEndpoints
	}
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - serviceId: the id of the data service
	///   - path: reference path
	/// - Returns: Binary Object
	@MainActor func loadBinary(
		_ healthcareOrganization: MgoOrganization,
		serviceId: String,
		path: String
	) async throws -> FHIRBinary? {
			
		// The binary call also needs the DVA Target header
		guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: serviceId),
				let dataService = DataServices(isDemo: Container.shared.featureFlagManager().isDemo).services.first(where: { $0.id == serviceId }) else {
			return nil
		}
		
		do {
			logVerbose("ResourceRepository - calling endpoint for \(dvaTarget)", path)
			
			let data = try await repository.getBundleData(
				endpoint: DataServices.Endpoint(id: "binary", path: path, profiles: []),
				fhirVersion: dataService.fhirVersionEnum,
				headers: MGORepositoryHeaders(
					dvaTarget: dvaTarget,
					dataServiceId: serviceId,
					medmijId: healthcareOrganization.identifier,
					username: username,
					password: password
				)
			)
			
			let binary = try FHIRBinary(data: data)
			return binary
		} catch {
			// Should be error
			return nil
		}
	}
}
