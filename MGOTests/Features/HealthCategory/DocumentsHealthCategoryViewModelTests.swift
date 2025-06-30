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
	private var healthcareOrganization: MgoOrganization!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1", name: "Ziekenhuis Nieuw Juinen")
		sut = DocumentsHealthCategoryViewModel(
			coordinator: coordinatorSpy,
			organization: healthcareOrganization
		)
	}

	@MainActor func test_loadResources_withResults_withName() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		let resource = try getResource("iheMhdMinimalDocumentReference")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.documents.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventuallyNot(equal(.loading))
		if case let HealthCategoryViewState.list(items) = sut.state {
			expect(items).toEventually(haveCount(1))
			expect(items[0].rows).toNot(beEmpty())
		} else {
			fail("Invalid state")
		}
	}

}
