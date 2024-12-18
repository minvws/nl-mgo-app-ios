/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import Zibs

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
	
	func loadBinary(
		_ healthcareOrganization: MgoOrganization,
		serviceId: String,
		url: String) async throws -> Zibs.Binary?
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
	
	/// The url of the resource server
	private var serverUrl: Foundation.URL
	
	/// the authentication username
	private var username: String?
	
	/// The authentication password
	private var password: String?
	
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
		self.serverUrl = serverUrl
		self.username = username
		self.password = password
		registerObservers()
	}
	
	// Listen to changes in the stored organizations list
	private func registerObservers() {
		
		self.observerToken = healthcareOrganizationRepository?.observatory.append { [weak self] organization, reason in
			switch reason {
				case .added:
					// New organization, load the data
					logVerbose("ResourceRepository observatory .added triggered for  \(organization.display_name)")
					self?.loadFor(organization)
					
				case .removed:
					// Remove stored data for the removed organization
					logVerbose("ResourceRepository observatory .removed for \(organization.display_name)")
					self?.dataRepository?.removeRecords(for: organization.identifier)
			}
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
		
		let repository = MGORepository(client: FHIRClient(baseURL: serverUrl))
//		let repository = MGORepository(client: FHIRClient(baseURL: URL(string: "http://localhost:8001/fhir/")!))
		
		for service in category.services {
			
			guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: service.serviceId) else {
//			guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: service.serviceId)?.replacingOccurrences(of: "dva-mock.test.mgo.prolocation.net", with: "mock") else {
				continue
			}
			
			var mgoResources = [MgoResource]()
			var resourceError = false
			
			do {
				logVerbose("ResourceRepository - calling endpoint for \(dvaTarget)", service)
				let data = try await repository.getBundleData(
					endpoint: service,
					dvaTarget: dvaTarget,
					username: username,
					password: password
				)
				mgoResources = try repository.process(data, fhirVersion: service.fhirVersion.rawValue)
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
		url: String) async throws -> Zibs.Binary? {
		
			let repository = MGORepository(client: FHIRClient(baseURL: serverUrl))
//			let repository = MGORepository(client: FHIRClient(baseURL: URL(string: "http://localhost:8001/fhir/")!))
			
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
				
				let binary = try Binary(data: data)
				return binary
			} catch {
				// Should be error
				return nil
			}
	}
}
