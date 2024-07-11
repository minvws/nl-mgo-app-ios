/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

public class LocalisationServiceClientSpy: LocalisationServiceClientProtocol {

	public required init() { /* Public initializer needed for public access */ }

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
}
