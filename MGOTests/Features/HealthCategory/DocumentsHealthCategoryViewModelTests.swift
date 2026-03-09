/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class DocumentsHealthCategoryViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: DocumentsHealthCategoryViewModel!
	private var healthcareOrganization: OrganizationSearch.Organization!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1", name: "Ziekenhuis Nieuw Juinen")
	}
	
	@MainActor private func createSut() throws {
		
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "documents"))
		
		sut = DocumentsHealthCategoryViewModel(
			coordinator: coordinatorSpy,
			category: category,
			organization: healthcareOrganization
		)
	}
	
	@MainActor func test_loadResources_withResults_withName() throws {
		
		// Given
		try createSut()
		let resource = try getResource("iheMhdMinimalDocumentReference")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[
				MgoResourceRecord(
					categoryId: "document",
					organizationId: healthcareOrganization.identifier,
					resources: [resource],
					error: nil
				)
			]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items, errorstate) = sut.state {
			expect(items).toEventually(haveCount(1))
			expect(items[0].rows).toNot(beEmpty())
			expect(errorstate) == HealthCategoriesErrorState.none
		} else {
			fail("Invalid state")
		}
	}
}
