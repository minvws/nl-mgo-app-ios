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
}

class ResourceRepository: ResourceRepositoryProtocol {
	
	/// Token for the observatory (needed for unregister)
	private var observerToken: Observatory.ObserverToken?
	
	private var healthcareOrganizationRepository: HealthcareOrganizationRepositoryProtocol?
	
	private var dataRepository: MgoDataStoreProtocol?
	
	init(healthcareOrganizationRepository: HealthcareOrganizationRepositoryProtocol, dataRepository: MgoDataStoreProtocol) {
		
		self.healthcareOrganizationRepository = healthcareOrganizationRepository
		self.dataRepository = dataRepository
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
			
			switch category {
				case .medication:
					_Concurrency.Task { try await loadResource(healthcareOrganization, category: .medication) }
				case .allergies:
					_Concurrency.Task { try await loadResource(healthcareOrganization, category: .allergies) }
				case .measurements:
					break
				case .vaccinations:
					break
				case .complaints:
					_Concurrency.Task { try await loadResource(healthcareOrganization, category: .complaints) }
				case .treatments:
					break
				case .labresults:
					break
				case .reports:
					break
				case .documents:
					break
			}
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
	private func loadResource(_ healthcareOrganization: MgoOrganization, category: HealthCategories.Category) async throws {
		
		guard let client = FHIRClient() else {
			return
		}
		let repository = MGORepository(client: client)
		
		for endpoint in category.endPoint {
			
			guard let dvaTarget = healthcareOrganization.getResourceEndpoint(identifier: endpoint.1) else {
				continue
			}
			
			logInfo("ResourceRepository - calling endpoint for \(dvaTarget)", endpoint)
			let data = try await repository.getBundleData(endpoint: endpoint.0, dvaTarget: dvaTarget)
			var mgoResources = try repository.process(data)
			
			mgoResources = mgoResources.filter { resource in
				
				var result = false
				for profile in category.acceptedProfiles {
					result = result || resource.hasProfile(profile)
				}
				return result
			}
			
			let recordToStore = MgoResourceRecord(categoryId: "\(category.rawValue)", organizationId: healthcareOrganization.identifier, resources: mgoResources)
			logInfo("ResourceRepository - Adding to the store", recordToStore)
			dataRepository?.store(data: recordToStore)
		}
	}
}
