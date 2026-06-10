/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOTest
import MGOFoundation
@testable import MGO

@MainActor
@Suite(.serialized)
struct ReferenceResolverTests {
	
	private let organization: OrganizationSearch.Organization = Generator.healthcareOrganization("1")
	private let sut: ReferenceResolver
	private let servicesSpies: ServicesSpies
	
	init() {
		servicesSpies = setupServicesSpies()
		sut = ReferenceResolver()
	}
	
	@Test("Resolving with no stored data returns nil")
	func resolve_noData() {
		
		// Given the data store has no data for the organization
		servicesSpies.dataStoreSpy.stubbedGetOrganizationIdResult = .failure(DataStoreError.noData)
		
		// When resolving a reference
		let resolved = sut.resolve(
			reference: "Reference",
			healthcareOrganization: organization
		)
		
		// Then nothing is resolved
		#expect(resolved == nil)
	}
	
	@Test("Resolving an errored record returns nil")
	func resolve_errorInData() {
		
		// Given a stored record flagged as errored
		let record = MgoResourceRecord(
			categoryId: "1",
			organizationId: organization.identifier,
			resources: [],
			error: true
		)
		servicesSpies.dataStoreSpy.stubbedGetOrganizationIdResult = .success([record])
		
		// When resolving a reference
		let resolved = sut.resolve(
			reference: "Reference",
			healthcareOrganization: organization
		)
		
		// Then nothing is resolved
		#expect(resolved == nil)
	}
	
	@Test("Resolving a reference absent from the resource returns nil")
	func resolve_noReferenceFound() throws {
		
		// Given a stored record whose resource does not contain the reference
		let resource = try getResource("zibProblem")
		let record = MgoResourceRecord(
			categoryId: "1",
			organizationId: organization.identifier,
			resources: [resource],
			error: false
		)
		servicesSpies.dataStoreSpy.stubbedGetOrganizationIdResult = .success([record])
		
		// When resolving a reference that is not present in the resource
		let resolved = sut.resolve(
			reference: "Reference",
			healthcareOrganization: organization
		)
		
		// Then nothing is resolved
		#expect(resolved == nil)
	}
	
	@Test("Resolving a matching reference returns the resource and its schema")
	func resolve_referenceFound() throws {
		
		// Given a stored record containing the referenced resource
		let resource = try getResource("zibProblem")
		let record = MgoResourceRecord(
			categoryId: "1",
			organizationId: organization.identifier,
			resources: [resource],
			error: nil
		)
		servicesSpies.dataStoreSpy.stubbedGetOrganizationIdResult = .success([record])
		
		// When resolving the matching reference
		let resolved = sut.resolve(
			reference: "Condition/3c77bb22-795d-4e5e-815e-1db080fca69f",
			healthcareOrganization: organization
		)
		let (data, schema) = try #require(resolved)
		
		// Then the resource and its mapped schema are returned
		#expect(data == resource)
		#expect(schema.label == "Medische klacht")
		#expect(schema.children.first?.label == nil)
		#expect(schema.children.first?.children.count == 2)
	}
}
