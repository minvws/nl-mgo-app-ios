/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing

@Suite(.serialized)
class HealthcareOrganizationRepositoryTests {

	init() {
		HealthcareOrganizationRepository().wipePersistedData()
	}

	@Test("Store an organization to disk")
	func storeToDisk() throws {

		// Given
		let sut = HealthcareOrganizationRepository()
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
		let sut = HealthcareOrganizationRepository()
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
		let sut = HealthcareOrganizationRepository()
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
		let sut = HealthcareOrganizationRepository()
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
		let sut = HealthcareOrganizationRepository()
		let organization = makeOrganization("1")
		try sut.store(organization)

		// When
		sut.wipePersistedData()
		let list = try sut.read()

		// Then
		#expect(list.isEmpty)
		#expect(sut.organizations.isEmpty)
	}

	func makeOrganization(
		_ id: String,
		city: String = "Roermond",
		address: String = "Boorplatform 5",
		postalCode: String = "1234AB"
	) -> Organization {
		return Organization(
			addressLine: address,
			careTypeDisplay: "Tandarts",
			city: city,
			displayName: "Tandarts Tandje Erbij",
			id: id,
			postalCode: postalCode
		)
	}
}
