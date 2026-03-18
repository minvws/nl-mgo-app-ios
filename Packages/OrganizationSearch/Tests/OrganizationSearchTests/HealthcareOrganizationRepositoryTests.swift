/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing

@Suite(.serialized)
class HealthcareOrganizationRepositoryTests {

	init() throws {
		try HealthcareOrganizationRepository().wipePersistedData()
	}

	@Test("Store an organization to disk")
	func storeToDisk() throws {

		// Given
		let sut = try HealthcareOrganizationRepository()
		let organization = makeOrganization("1")

		// When
		try sut.store(organization)
		let list = try sut.read()

		// Then
		#expect(list.count == 1)
		#expect(list.first == organization)
		#expect(sut.organizations.count == 1)
		#expect(sut.organizations == list)
	}

	@Test("Storing the same organization twice saves just one")
	func storeToDiskTwice_savesJustOne() throws {

		// Given
		let sut = try HealthcareOrganizationRepository()
		let organization = makeOrganization("1")

		// When
		try sut.store(organization)
		try sut.store(organization)
		let list = try sut.read()

		// Then
		#expect(list.count == 1)
		#expect(list.first == organization)
		#expect(sut.organizations.count == 1)
		#expect(sut.organizations == list)
	}

	@Test("Remove a stored organization from disk")
	func storeAndRemoveToDisk() throws {

		// Given
		let sut = try HealthcareOrganizationRepository()
		let organization = makeOrganization("1")
		try sut.store(organization)

		// When
		try sut.remove(organization)
		let list = try sut.read()

		// Then
		#expect(list.isEmpty)
		#expect(sut.organizations.isEmpty)
	}

	@Test("Set replaces the stored list")
	func set() throws {

		// Given
		let sut = try HealthcareOrganizationRepository()
		let organization = makeOrganization("1")

		// When
		try sut.set([organization])

		// Then
		let list = try sut.read()
		#expect(list.count == 1)
		#expect(list.first == organization)
	}

	@Test("Wipe persistent data clears all stored organizations")
	func wipePersistentData() throws {

		// Given
		let sut = try HealthcareOrganizationRepository()
		let organization = makeOrganization("1")
		try sut.store(organization)

		// When
		sut.wipePersistedData()
		let list = try sut.read()

		// Then
		#expect(list.isEmpty)
		#expect(sut.organizations.isEmpty)
	}

	@Test("Data services round-trip through SQLite")
	func dataServicesRoundTrip() throws {

		// Given
		let dataService = DataService(
			id: "urn:oid:2.16.840.1.113883.2.4.3.11.58.1",
			authEndpoint: "https://example.com/auth",
			resourceEndpoint: "https://example.com/fhir",
			tokenEndpoint: "https://example.com/token"
		)
		let organization = makeOrganization("1", dataServices: [dataService])
		let sut = try HealthcareOrganizationRepository()

		// When
		try sut.store(organization)
		let stored = try sut.read()

		// Then
		let storedService = try #require(stored.first?.dataServices?.first(where: { $0.id == "urn:oid:2.16.840.1.113883.2.4.3.11.58.1" }))
		#expect(storedService.authEndpoint == dataService.authEndpoint)
		#expect(storedService.resourceEndpoint == dataService.resourceEndpoint)
		#expect(storedService.tokenEndpoint == dataService.tokenEndpoint)
	}

	private func makeOrganization(
		_ id: String,
		city: String = "Roermond",
		address: String = "Boorplatform 5",
		postalCode: String = "1234AB",
		dataServices: [DataService]? = nil
	) -> Organization {
		return Organization(
			address: OrganizationAddress(
				address: address,
				city: city,
				postalCode: postalCode
			),
			careType: "Tandarts",
			dataServices: dataServices,
			id: id,
			name: "Tandarts Tandje Erbij"
		)
	}
}
