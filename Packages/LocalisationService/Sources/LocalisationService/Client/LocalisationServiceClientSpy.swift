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

	public required init() {
		// Public initializer needed for public access. 
	}

	public var invokedSearchHealthcareProviders = false
	public var invokedSearchHealthcareProvidersCount = 0
	public var invokedSearchHealthcareProvidersParameters: (city: String, name: String)?
	public var invokedSearchHealthcareProvidersParametersList = [(city: String, name: String)]()
	public var stubbedSearchHealthcareProviders = [HealthcareProvider]()
	public var stubbedSearchHealthcareProviderError: Error?
	
	private let queue = DispatchQueue(label: "com.LocalisationServiceClientSpy.serialqueue.\(UUID().uuidString)")

	public func searchHealthcareProviders(city: String, name: String) async throws -> [HealthcareProvider] {
		
		queue.sync {
			invokedSearchHealthcareProviders = true
			invokedSearchHealthcareProvidersCount += 1
			invokedSearchHealthcareProvidersParameters = (city, name)
			invokedSearchHealthcareProvidersParametersList.append((city, name))
		}
		
		if let error = stubbedSearchHealthcareProviderError {
			throw error
		}
		return stubbedSearchHealthcareProviders
	}
}
