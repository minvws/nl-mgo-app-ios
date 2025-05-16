/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

public class LocalisationServiceClientSpy: LocalisationServiceClientProtocol {
	
	public required init(serverUrl: Foundation.URL, username: String?, password: String?) { /* Public initializer needed for public access */ }
	
	public var invokedSearchHealthcareOrganizations = false
	public var invokedSearchHealthcareOrganizationsCount = 0
	public var invokedSearchHealthcareOrganizationsParameters: (city: String, name: String)?
	public var invokedSearchHealthcareOrganizationsParametersList = [(city: String, name: String)]()
	public var stubbedSearchHealthcareOrganizations = [MgoOrganization]()
	public var stubbedSearchHealthcareOrganizationError: Error?
	
	private let queue = DispatchQueue(label: "com.LocalisationServiceClientSpy.serialqueue.\(UUID().uuidString)")
	
	public func searchHealthcareOrganizations(city: String, name: String) async throws -> [MgoOrganization] {
		
		queue.sync {
			invokedSearchHealthcareOrganizations = true
			invokedSearchHealthcareOrganizationsCount += 1
			invokedSearchHealthcareOrganizationsParameters = (city, name)
			invokedSearchHealthcareOrganizationsParametersList.append((city, name))
		}
		
		if let error = stubbedSearchHealthcareOrganizationError {
			throw error
		}
		return stubbedSearchHealthcareOrganizations
	}
	
	public var invokedSearchDemoOrganizations = false
	public var invokedSearchDemoOrganizationsCount = 0
	public var stubbedSearchDemoOrganizations = [MgoOrganization]()
	public var stubbedSearchDemoOrganizationError: Error?
	
	public func searchDemoOrganizations() async throws -> [MgoOrganization] {
		
		queue.sync {
			
			invokedSearchDemoOrganizations = true
			invokedSearchDemoOrganizationsCount += 1
		}
		if let error = stubbedSearchDemoOrganizationError {
			throw error
		}
		
		return stubbedSearchDemoOrganizations
	}
}
