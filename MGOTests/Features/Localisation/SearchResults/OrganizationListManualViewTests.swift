/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class OrganizationListManualViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var localisationServiceClientSpy: LocalisationServiceClientSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: OrganizationListManualViewModel!
	private var sut: OrganizationListManualView!

	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		localisationServiceClientSpy = LocalisationServiceClientSpy(
			serverUrl: serverUrl,
			username: "test",
			password: "test"
		)
	}
	
	private func createSut(city: String = "Roermond", name: String = "Tandarts Tandje Erbij") {
		
		viewModel = OrganizationListManualViewModel(
			coordinator: coordinatorSpy,
			city: city,
			name: name,
			localisationServiceClient: localisationServiceClientSpy
		)
		sut = OrganizationListManualView(viewModel: self.viewModel)
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
	
	func test_backbuttonPressed() throws {
		
		// Given
		createSut()
		viewModel.state = .loading
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_empty() {
		
		// Given
		createSut()
		viewModel.state = .empty(city: "Roermond", name: "Tandarts Tandje Erbij")

		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
		takeSnapShotsForiPad(content: content)
	}
	
	func test_empty_action() throws {
		
		// Given
		createSut()
		viewModel.state = .empty(city: "Roermond", name: "Tandarts Tandje Erbij")
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "action_button")
		try view.view(CallToActionButton.self).find(button: "common.search_again").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backToAddHealthcareOrganization
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
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
		expect(self.viewModel.state).toEventually(equal(.empty(city: "Roermond", name: "Tandarts Tandje Erbij")))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareOrganizations).toEventually(beTrue(), timeout: .seconds(5))
	}
	
	func test_list_lightPortrait() {
		
		// Given
		createSut()
		let list: [OrganizationListSet] = [
			((Generator.healthcareOrganization("1"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("2"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("3"), OrganizationListCardState.selected)),
			((Generator.healthcareOrganization("4", city: "", address: "", postalCode: ""), OrganizationListCardState.regular))
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
			((Generator.healthcareOrganization("1"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("2"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("3"), OrganizationListCardState.selected)),
			((Generator.healthcareOrganization("4", city: "", address: "", postalCode: ""), OrganizationListCardState.regular))
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
			((Generator.healthcareOrganization("1"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("2"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("3"), OrganizationListCardState.selected)),
			((Generator.healthcareOrganization("4", city: "", address: "", postalCode: ""), OrganizationListCardState.regular))
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
			((Generator.healthcareOrganization("1"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("2"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("3"), OrganizationListCardState.selected)),
			((Generator.healthcareOrganization("4", city: "", address: "", postalCode: ""), OrganizationListCardState.regular))
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
