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
		HealthcareProviderRepository().wipePersistedData()
	}

	func test_storeToDisk() throws {
		
		// Given
		let sut = HealthcareProviderRepository()
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
		let sut = HealthcareProviderRepository()
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
		let sut = HealthcareProviderRepository()
		let provider = healthcareProvider("1")
		try sut.store(provider)
		
		// When
		try sut.remove(provider)
		let list = try sut.read()
		
		// Then
		expect(list).to(beEmpty())
		expect(sut.providers).to(beEmpty())
	}
	
	func test_wipePersistentData() throws {
		
		// Given
		let sut = HealthcareProviderRepository()
		let provider = healthcareProvider("1")
		try sut.store(provider)
		
		// When
		sut.wipePersistedData()
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
			],
			data_services: []
		)
	}
}
