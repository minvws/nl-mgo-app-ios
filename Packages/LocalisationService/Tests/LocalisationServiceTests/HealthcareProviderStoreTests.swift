/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import LocalisationService
import MGOTest

final class HealthcareProviderStoreTests: XCTestCase {
	
	override func tearDown() {
		super.tearDown()
		HealthcareOrganizationRepository().wipePersistedData()
	}

	func test_storeToDisk() throws {
		
		// Given
		let sut = HealthcareOrganizationRepository()
		let provider = healthcareOrganization("1")
		
		// When
		try sut.store(provider)
		let list = try sut.read()
		
		// Then
		expect(list).to(haveCount(1))
		expect(list.first) == provider
		expect(sut.organizations).to(haveCount(1))
		expect(sut.organizations) == list
	}
	
	func test_storeToDiskTwice_savesJustOne() throws {
		
		// Given
		let sut = HealthcareOrganizationRepository()
		let provider = healthcareOrganization("1")
		
		// When
		try sut.store(provider)
		try sut.store(provider)
		let list = try sut.read()
		
		// Then
		expect(list).to(haveCount(1))
		expect(list.first) == provider
		expect(sut.organizations).to(haveCount(1))
		expect(sut.organizations) == list
	}

	func test_storeAndRemoveToDisk() throws {
		
		// Given
		let sut = HealthcareOrganizationRepository()
		let provider = healthcareOrganization("1")
		try sut.store(provider)
		
		// When
		try sut.remove(provider)
		let list = try sut.read()
		
		// Then
		expect(list).to(beEmpty())
		expect(sut.organizations).to(beEmpty())
	}
	
	func test_wipePersistentData() throws {
		
		// Given
		let sut = HealthcareOrganizationRepository()
		let provider = healthcareOrganization("1")
		try sut.store(provider)
		
		// When
		sut.wipePersistedData()
		let list = try sut.read()
		
		// Then
		expect(list).to(beEmpty())
		expect(sut.organizations).to(beEmpty())
	}
	
	func healthcareOrganization(_ id: String, city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB") -> HealthcareOrganization {
		return HealthcareOrganization(
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
