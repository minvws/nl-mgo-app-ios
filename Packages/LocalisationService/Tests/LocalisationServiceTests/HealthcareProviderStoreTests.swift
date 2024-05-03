/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import LocalisationService
import XCTest
import Nimble

final class HealthcareProviderStoreTests: XCTestCase {
	
	override func tearDown() {
		super.tearDown()
		HealthcareProviderStore().wipePersistedData()
	}

	func test_storeToDisk() throws {
		
		// Given
		let sut = HealthcareProviderStore()
		let provider = healthcareProvider("1")
		
		// When
		try sut.store(provider)
		let list = try sut.read()
		
		// Then
		expect(list).to(haveCount(1))
		expect(list.first) == provider
		expect(sut.providers).to(haveCount(1))
		expect(sut.providers) == list
	}
	
	func test_storeToDiskTwice_savesJustOne() throws {
		
		// Given
		let sut = HealthcareProviderStore()
		let provider = healthcareProvider("1")
		
		// When
		try sut.store(provider)
		try sut.store(provider)
		let list = try sut.read()
		
		// Then
		expect(list).to(haveCount(1))
		expect(list.first) == provider
		expect(sut.providers).to(haveCount(1))
		expect(sut.providers) == list
	}

	func test_storeAndRemoveToDisk() throws {
		
		// Given
		let sut = HealthcareProviderStore()
		let provider = healthcareProvider("1")
		try sut.store(provider)
		
		// When
		try sut.remove(provider)
		let list = try sut.read()
		
		// Then
		expect(list).to(beEmpty())
		expect(sut.providers).to(beEmpty())
	}
	
	func healthcareProvider(_ id: String, city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB") -> HealthcareProvider {
		return HealthcareProvider(
			display_name: "Tandarts Tandje Erbij",
			identification_type: "type",
			identification_value: id,
			active: true,
			addresses: [Components.Schemas.Address(
				active: true,
				address: "\(address) \r\n \(postalCode) \(city)",
				city: city,
				lines: [address],
				postalcode: postalCode,
				_type: "postal")
			],
			names: [],
			types: [
				Components.Schemas.CType(
					code: "01",
					display_name: "Tandarts",
					_type: ""
				)
			]
		)
	}
}

/*
 
 var providers: [HealthcareProvider] { get }
 
 /// Add a healthcare provider to the storage
 /// - Parameter provider: the healthcare provider to store
 func store(_ provider: HealthcareProvider) throws
 
 /// Get a list of all the stored healthcare providers
 /// - Returns: array of healthcare providers
 func read() throws -> [HealthcareProvider]
 
 /// Delete a healthcare provider from storage
 /// - Parameter provider: the healthcare provider to be removed
 func remove(_ provider: HealthcareProvider) throws
 
 /// Remove all the healthcare providers
 func wipe()
 
 */
