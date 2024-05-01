/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import LocalisationServiceClient

protocol HealthcareProviderStoreProtocol {
	
	func store(_ provider: HealthcareProvider) throws
	
	func read() async throws -> [HealthcareProvider]
	
	func remove(_ provider: HealthcareProvider) throws
}

class HealthcareProviderStore: HealthcareProviderStoreProtocol {
	
	private let queue = DispatchQueue(label: "com.healthcareProviderStore.serialqueue.\(UUID().uuidString)")
	
	private var list = [HealthcareProvider]()
	
	func store(_ provider: HealthcareProvider) throws {
		
		queue.sync {
			list.append(provider)
		}}
	
	func read() async throws -> [HealthcareProvider] {
		return list
	}
	
	func remove(_ provider: HealthcareProvider) throws {
		
		queue.sync {
			list = list.filter { $0 != provider }
		}
	}
}
