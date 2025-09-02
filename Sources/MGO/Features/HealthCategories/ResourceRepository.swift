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
	@MainActor func loadFor(_ category: HealthCategories.Category) async
	
	/// Load all the categories for a category
	/// - Parameter category: the category to load  for
	@MainActor func loadFor(_ category: SharedHealthCategories.Category) async

	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - category: the category to load the resources for.
	@MainActor func loadResource(_ healthcareOrganization: MgoOrganization, category: HealthCategories.Category) async
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - category: the category to load the resources for.
	@MainActor func loadResource(_ healthcareOrganization: MgoOrganization, category: SharedHealthCategories.Category) async
	
	/// Load a binary object
	/// - Parameters:
	///   - healthcareOrganization: the healthcare organization
	///   - serviceId: the service id
	///   - url: the url of the binary
	/// - Returns: Optional Binary
	@MainActor func loadBinary(
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
			self?.handleOrganizationChanges(organization, reason: reason)
		}
	}
	
	/// Handle changes in the organizations list
	/// - Parameters:
	///   - organization: optional organization added or removed
	///   - reason: the reason the list has changed
	@MainActor func handleOrganizationChanges(_ organization: MgoOrganization?, reason: HealthcareOrganizationReason) {
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
		logVerbose("ResourceRepository - LoadFor", healthcareOrganization.identifier)
		for category in HealthCategories.Category.allCases {
			_Concurrency.Task(priority: .high) {
				await loadResource(healthcareOrganization, category: category)
			}
		}
	}
	
	/// Load all the categories for a category
	/// - Parameter category: the category to load  for
	@MainActor func loadFor(_ category: HealthCategories.Category) async {
		logVerbose("ResourceRepository - LoadFor", category)
		
		guard let healthcareOrganizationRepository else { return }
		
		for healthcareOrganization in healthcareOrganizationRepository.organizations {
			await loadResource(healthcareOrganization, category: category)
		}
	}
	
	/// Load all the categories for a category
	/// - Parameter category: the category to load  for
	@MainActor func loadFor(_ category: SharedHealthCategories.Category) async {
		logVerbose("ResourceRepository - LoadFor", category)
		
		guard let healthcareOrganizationRepository else { return }
		
		for healthcareOrganization in healthcareOrganizationRepository.organizations {
			await loadResource(healthcareOrganization, category: category)
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
		category: HealthCategories.Category
	) async {
		
		logVerbose("\n\nStarting for category:", category)
		
		let dataServices = DataServices()
		if let sharedCategory = category.sharedCategory {
			for dataService in dataServices.services {
				
				// Check if the organization uses this data service
				guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: dataService.id) else {
					continue
				}
				
				// Set of endpoints to use. a set to filter duplicates
				var usableEndpoints = Set<DataServices.Endpoint>()
				for endpoint in dataService.endpoints {
					for dsProfile in endpoint.profiles {
						for subcategory in sharedCategory.subcategories {
							for scProfile in subcategory.profiles where scProfile == dsProfile {
								usableEndpoints.insert(endpoint)
							}
						}
					}
				}
				logVerbose("Usable endpoints", usableEndpoints)
				for endpoint in usableEndpoints {
					
					var mgoResources = [MgoResource]()
					var resourceError = false
		
					do {
						logVerbose("ResourceRepository - calling endpoint for \(dvaTarget)", endpoint)
						let fhirBundle = try await repository.getBundleData(
							endpoint: endpoint,
							fhirVersion: dataService.fhirVersion,
							dvaTarget: dvaTarget,
							username: username,
							password: password
						)
						
						mgoResources = try await repository.process(
							fhirBundle,
							fhirVersion: dataService.fhirVersion.rawValue
						)
					} catch {
						resourceError = true
					}
					
					let recordToStore = MgoResourceRecord(
						categoryId: sharedCategory.id,
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
		}
	}
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - category: the category to load the resources for.
	@MainActor func loadResource(
		_ healthcareOrganization: MgoOrganization,
		category: SharedHealthCategories.Category
	) async {
		
		logVerbose("\n\nStarting for category:", category)
		
		let dataServices = DataServices()
		
		for dataService in dataServices.services {
			
			// Check if the organization uses this data service
			guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: dataService.id) else {
				continue
			}
			
			// Set of endpoints to use. a set to filter duplicates
			var usableEndpoints = Set<DataServices.Endpoint>()
			for endpoint in dataService.endpoints {
				for dsProfile in endpoint.profiles {
					for subcategory in category.subcategories {
						for scProfile in subcategory.profiles where scProfile == dsProfile {
							usableEndpoints.insert(endpoint)
						}
					}
				}
			}
			logVerbose("Usable endpoints", usableEndpoints)
			for endpoint in usableEndpoints {
				
				var mgoResources = [MgoResource]()
				var resourceError = false
				
				do {
					logVerbose("ResourceRepository - calling endpoint for \(dvaTarget)", endpoint)
					let fhirBundle = try await repository.getBundleData(
						endpoint: endpoint,
						fhirVersion: dataService.fhirVersion,
						dvaTarget: dvaTarget,
						username: username,
						password: password
					)
					
					mgoResources = try await repository.process(
						fhirBundle,
						fhirVersion: dataService.fhirVersion.rawValue
					)
				} catch {
					resourceError = true
				}
				
				let recordToStore = MgoResourceRecord(
					categoryId: "\(category.id)",
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
	}
	
	/// Load the resources
	/// - Parameters:
	///   - healthcareOrganization: healthcare organization
	///   - serviceId: the id of the data service
	///   - url: reference url
	/// - Returns: Binary Object
	@MainActor func loadBinary(
		_ healthcareOrganization: MgoOrganization,
		serviceId: String,
		url: String
	) async throws -> FHIRBinary? {
			
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
