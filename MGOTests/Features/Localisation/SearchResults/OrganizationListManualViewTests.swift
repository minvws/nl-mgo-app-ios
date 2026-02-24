/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@preconcurrency import MGOTest
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
	
	@MainActor private func createSut(
		city: String = "Roermond",
		name: String = "Tandarts Tandje Erbij",
		state: OrganizationListViewState
	) {
		
		viewModel = OrganizationListManualViewModel(
			coordinator: coordinatorSpy,
			city: city,
			name: name,
			localisationServiceClient: localisationServiceClientSpy
		)
		viewModel.state = state
		sut = OrganizationListManualView(viewModel: self.viewModel)
	}
	
	@MainActor func test_backbuttonPressed() throws {
		
		// Given
		createSut(state: .loading)
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	@MainActor func test_empty_action() throws {
		
		// Given
		createSut(state: .empty(city: "Roermond", name: "Tandarts Tandje Erbij"))
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "action_button")
		try view.view(CallToActionButton.self).find(button: "common.search_again").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backToAddHealthcareOrganization
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
	}

	@MainActor func test_failure() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let error = NSError(domain: "SearchResultViewModelTests", code: 404)
		createSut(state: .failure(error))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_failure_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		let error = NSError(domain: "SearchResultViewModelTests", code: 404)
		createSut(state: .failure(error))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_failure_action() async throws {
		
		// Given
		let error = NSError(domain: "SearchResultViewModelTests", code: 404)
		createSut(state: .failure(error))
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "action_button")
		try view.view(CallToActionButton.self).find(button: "common.try_again").tap()
		
		// Then
		await expect(self.viewModel.state).toEventually(equal(.empty(city: "Roermond", name: "Tandarts Tandje Erbij")))
		let didInvokeSearchHealthcareOrganizations = await localisationServiceClientSpy.didInvokeSearchHealthcareOrganizations()
		await expect(didInvokeSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_list() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let list: [OrganizationListSet] = [
			((Generator.healthcareOrganization("1"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("2"), OrganizationListCardState.notParticipating)),
			((Generator.healthcareOrganization("3"), OrganizationListCardState.selected)),
			((Generator.healthcareOrganization("4", city: "", address: "", postalCode: ""), OrganizationListCardState.regular))
		]
		createSut(state: .success(list))
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
