/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

class ReferenceResolverTests: XCTestCase {
	
	private let organization: MgoOrganization = Generator.healthcareOrganization("1")
	
	private var reference = "Reference"
	
	private var sut: ReferenceResolver!
	
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		
		servicesSpies = setupServicesSpies()
		sut = ReferenceResolver()
	}
	
	func test_resolve_noData() {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetOrganizationIdResult = .failure(DataStoreError.noData)
		
		// When
		let resolved = sut.resolve(reference: reference, healthcareOrganization: organization)
		
		// Then
		expect(resolved) == nil
	}
	
	func test_resolve_errorInData() {
		
		// Given
		let record = MgoResourceRecord(
			categoryId: "1",
			organizationId: organization.identification,
			resources: [],
			error: true
		)
		servicesSpies.dataStoreSpy.stubbedGetOrganizationIdResult = .success([record])
		
		// When
		let resolved = sut.resolve(reference: reference, healthcareOrganization: organization)
		
		// Then
		expect(resolved) == nil
	}
	
	func test_resolve_noReferenceFound() throws {
		
		// Given
		let resource = try getResource("zibProblem")
		
		let record = MgoResourceRecord(
			categoryId: "1",
			organizationId: organization.identification,
			resources: [resource],
			error: false
		)
		servicesSpies.dataStoreSpy.stubbedGetOrganizationIdResult = .success([record])
		
		// When
		let resolved = sut.resolve(reference: reference, healthcareOrganization: organization)
		
		// Then
		expect(resolved) == nil
	}

	func test_resolve_referenceFound() throws {
		
		// Given
		let resource = try getResource("zibProblem")
		let record = MgoResourceRecord(
			categoryId: "1",
			organizationId: organization.identification,
			resources: [resource],
			error: false
		)
		servicesSpies.dataStoreSpy.stubbedGetOrganizationIdResult = .success([record])
		reference = "Condition/3c77bb22-795d-4e5e-815e-1db080fca69f"
		
		// When
		let resolved = sut.resolve(reference: reference, healthcareOrganization: organization)
		let (data, schema) = try XCTUnwrap(resolved)
		
		// Then
		expect(data) == resource
		expect(schema.label) == "Amyotrofe laterale sclerose"
	}
}
