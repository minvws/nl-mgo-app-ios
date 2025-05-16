/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

protocol ResourceRepositoryProtocol {
	
	/// Load all the categories for all the stored healthcare organizations
	func load()
	
	/// Load all the categories for a healthcare organization
	/// - Parameter healthcareOrganization: the healthcare organization to load all the categories for
	func loadFor(_ healthcareOrganization: MgoOrganization)
	
	/// Load all the categories for a category
	/// - Parameter category: the category to load  for
	func loadFor(_ category: HealthCategories.Category) async
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - category: the category to load the resources for.
	func loadResource(_ healthcareOrganization: MgoOrganization, category: HealthCategories.Category) async
	
	/// Load a binary object
	/// - Parameters:
	///   - healthcareOrganization: the healthcare organization
	///   - serviceId: the service id
	///   - url: the url of the binary
	/// - Returns: Optional Binary
	func loadBinary(
		_ healthcareOrganization: MgoOrganization,
		serviceId: String,
		url: String) async throws -> FHIRBinary?
}

/// Load the resources from the server
class ResourceRepository: ResourceRepositoryProtocol {
	
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
	init(
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
//		self.repository = MGORepository(client: FHIRClient(baseURL: URL(string: "http://localhost:8001/fhir/")!))
		self.username = username
		self.password = password
		registerObservers()
	}
	
	/// Listen to changes in the stored organizations list
	private func registerObservers() {
		
		self.observerToken = healthcareOrganizationRepository?.observatory.append { [weak self] organization, reason in
			self?.handleOrganizationChanges(organization, reason: reason)
		}
	}
	
	/// Handle changes in the organizations list
	/// - Parameters:
	///   - organization: optional organization added or removed
	///   - reason: the reason the list has changed
	func handleOrganizationChanges(_ organization: MgoOrganization?, reason: HealthcareOrganizationReason) {
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
	func loadFor(_ healthcareOrganization: MgoOrganization) {
		logVerbose("ResourceRepository - LoadFor", healthcareOrganization.identifier)
		for category in HealthCategories.Category.allCases {
			_Concurrency.Task { await loadResource(healthcareOrganization, category: category) }
		}
	}
	
	/// Load all the categories for a category
	/// - Parameter category: the category to load  for
	func loadFor(_ category: HealthCategories.Category) async {
		logVerbose("ResourceRepository - LoadFor", category)
		
		guard let healthcareOrganizationRepository else { return }
		
		for healthcareOrganization in healthcareOrganizationRepository.organizations {
			_Concurrency.Task { await loadResource(healthcareOrganization, category: category) }
		}
	}
	
	/// Load all the categories for all the stored healthcare organizations
	func load() {
		
		guard let healthcareOrganizationRepository else { return }
		
		for healthcareOrganization in healthcareOrganizationRepository.organizations {
			loadFor(healthcareOrganization)
		}
	}
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - category: the category to load the resources for.
	func loadResource(_ healthcareOrganization: MgoOrganization, category: HealthCategories.Category) async {
		
		for service in category.services {
			
			guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: service.serviceId) else {
				continue
			}
			
			var mgoResources = [MgoResource]()
			var resourceError = false
			
			do {
				logVerbose("ResourceRepository - calling endpoint for \(dvaTarget)", service)
				let fhirBundle = try await repository.getBundleData(
					endpoint: service,
					dvaTarget: dvaTarget,
					username: username,
					password: password
				)
				mgoResources = try repository.process(fhirBundle, fhirVersion: service.fhirVersion.rawValue)
			} catch {
				resourceError = true
			}
			
			#warning("To do: store data service id?")
			let recordToStore = MgoResourceRecord(categoryId: "\(category.rawValue)", organizationId: healthcareOrganization.identifier, resources: mgoResources, error: resourceError)
			logVerbose("ResourceRepository - Adding to the store", recordToStore)
			
			delay(Current.featureFlagManager.isDemo ? 5 : 0) {
				self.dataRepository?.store(data: recordToStore)
			}
		}
	}
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - serviceId: the id of the data service
	///   - url: reference url
	/// - Returns: Binary Object
	func loadBinary(
		_ healthcareOrganization: MgoOrganization,
		serviceId: String,
		url: String) async throws -> FHIRBinary? {
			
			// The binary call also needs the DVA Target header
			guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: serviceId) else {
				return nil
			}
			
			let endpoint = DVP.Endpoint(path: url, serviceId: serviceId)
		
			do {
				logInfo("ResourceRepository - calling endpoint for \(dvaTarget)", endpoint)
				let data = try await repository.getBundleData(
					endpoint: endpoint,
					dvaTarget: dvaTarget,
					username: username,
					password: password
				)
				
				let binary = try FHIRBinary(data: data)
				return binary
			} catch {
				// Should be error
				return nil
			}
	}
}
