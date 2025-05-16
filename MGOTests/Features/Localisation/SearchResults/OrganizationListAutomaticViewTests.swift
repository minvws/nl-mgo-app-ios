/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class OrganizationListAutomaticViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var localisationServiceClientSpy: LocalisationServiceClientSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: OrganizationListAutomaticViewModel!
	private var sut: OrganizationListAutomaticView!

	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = true
		coordinatorSpy = AppCoordinatorSpy()
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		localisationServiceClientSpy = LocalisationServiceClientSpy(serverUrl: serverUrl, username: nil, password: nil)
	}
	
	private func createSut(preselectAllOrganizations: Bool = true) {
		
		viewModel = OrganizationListAutomaticViewModel(
			coordinator: coordinatorSpy,
			localisationServiceClient: localisationServiceClientSpy,
			preselectAllOrganizations: preselectAllOrganizations
		)
		
		sut = OrganizationListAutomaticView(viewModel: self.viewModel)
	}
	
	func test_loading() {
		
		// Given
		createSut()
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_failure() {
		
		// Given
		createSut()
		let error = NSError(domain: "SearchResultViewModelTests", code: 404)
		viewModel.state = .failure(error)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_failure_action() throws {
		
		// Given
		createSut()
		let error = NSError(domain: "SearchResultViewModelTests", code: 404)
		viewModel.state = .failure(error)
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "action_button")
		try view.view(CallToActionButton.self).find(button: "common.try_again").tap()
		
		// Then
		viewModel.state = .failure(error)
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue(), timeout: .seconds(5))
	}
	
	func test_list_lightPortrait() {
		
		// Given
		createSut()
		let list: [OrganizationListSet] = [
			((Generator.healthcareOrganization("1"), OrganizationListCardState.automatic(isSelected: true))),
			((Generator.healthcareOrganization("2"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("3", withLines: false), OrganizationListCardState.automatic(isSelected: false))),
			((Generator.healthcareOrganization("4", city: "", address: "", postalCode: ""), OrganizationListCardState.selected))
		]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPhone16Pro(.portrait), precision: 1.0)
		)
	}
	
	func test_list_darkPortrait() {
		
		// Given
		createSut()
		let list: [OrganizationListSet] = [
			((Generator.healthcareOrganization("1"), OrganizationListCardState.automatic(isSelected: true))),
			((Generator.healthcareOrganization("2"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("3", withLines: false), OrganizationListCardState.automatic(isSelected: false))),
			((Generator.healthcareOrganization("4", city: "", address: "", postalCode: ""), OrganizationListCardState.selected))
		]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPhone16Pro(.portrait), precision: 1.0)
		)
	}
	
	func test_list_lightLandscape() {
		
		// Given
		createSut()
	let list: [OrganizationListSet] = [
		((Generator.healthcareOrganization("1"), OrganizationListCardState.automatic(isSelected: true))),
		((Generator.healthcareOrganization("2"), OrganizationListCardState.notParticipating)),
		((Generator.healthcareOrganization("3"), OrganizationListCardState.automatic(isSelected: false))),
		((Generator.healthcareOrganization("4", city: "", address: "", postalCode: ""), OrganizationListCardState.selected))
	]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.light)),
			as: .image(on: .iPhone16Pro(.landscape), precision: 1.0)
		)
	}
	
	func test_list_darkLandscape() {
		
		// Given
		createSut()
		let list: [OrganizationListSet] = [
			((Generator.healthcareOrganization("1"), OrganizationListCardState.automatic(isSelected: true))),
			((Generator.healthcareOrganization("2"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("3"), OrganizationListCardState.automatic(isSelected: false))),
			((Generator.healthcareOrganization("4", city: "", address: "", postalCode: ""), OrganizationListCardState.selected))
		]
		viewModel.state = .success(list)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		assertSnapshot(
			of: UIHostingController(rootView: content.colorScheme(.dark)),
			as: .image(on: .iPhone16Pro(.landscape), precision: 1.0)
		)
	}
}
