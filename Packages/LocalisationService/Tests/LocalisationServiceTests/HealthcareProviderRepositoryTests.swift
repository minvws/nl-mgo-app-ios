/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import LocalisationService
import MGOTest

final class HealthcareOrganiationRepositoryTests: XCTestCase {
	
	override func tearDown() {
		super.tearDown()
		HealthcareOrganizationRepository().wipePersistedData()
	}

	func test_storeToDisk() throws {
		
		// Given
		let sut = HealthcareOrganizationRepository()
		let organization = healthcareOrganization("1")
		
		// When
		try sut.store(organization)
		let list = try sut.read()
		
		// Then
		expect(list).to(haveCount(1))
		expect(list.first) == organization
		expect(sut.organizations).to(haveCount(1))
		expect(sut.organizations) == list
	}
	
	func test_storeToDiskTwice_savesJustOne() throws {
		
		// Given
		let sut = HealthcareOrganizationRepository()
		let organization = healthcareOrganization("1")
		
		// When
		try sut.store(organization)
		try sut.store(organization)
		let list = try sut.read()
		
		// Then
		expect(list).to(haveCount(1))
		expect(list.first) == organization
		expect(sut.organizations).to(haveCount(1))
		expect(sut.organizations) == list
	}

	func test_storeAndRemoveToDisk() throws {
		
		// Given
		let sut = HealthcareOrganizationRepository()
		let organization = healthcareOrganization("1")
		try sut.store(organization)
		
		// When
		try sut.remove(organization)
		let list = try sut.read()
		
		// Then
		expect(list).to(beEmpty())
		expect(sut.organizations).to(beEmpty())
	}
	
	func test_set() throws {
		
		// Given
		let sut = HealthcareOrganizationRepository()
		let organization = healthcareOrganization("1")
		
		// When
		try sut.set([organization])
		
		// Then
		let list = try sut.read()
		expect(list).to(haveCount(1))
		expect(list.first) == organization
	}
	
	func test_wipePersistentData() throws {
		
		// Given
		let sut = HealthcareOrganizationRepository()
		let organization = healthcareOrganization("1")
		try sut.store(organization)
		
		// When
		sut.wipePersistedData()
		let list = try sut.read()
		
		// Then
		expect(list).to(beEmpty())
		expect(sut.organizations).to(beEmpty())
	}
	
	func healthcareOrganization(_ id: String, city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB") -> MgoOrganization {
		return MgoOrganization(
			medmij_id: "test",
			display_name: "Tandarts Tandje Erbij",
			identification: id,
			addresses: [Components.Schemas.Address(
				active: true,
				address: "\(address) \r\n \(postalCode) \(city)",
				city: city,
				lines: [address],
				postalcode: postalCode,
				_type: "postal")
			],
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
