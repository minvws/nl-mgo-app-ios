/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class LoginViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var remoteAuthenticationClientSpy: RemoteAuthenticationClientSpy!
	private var viewModel: LoginViewModel!
	private var servicesSpies: ServicesSpies!
	private var sut: LoginView!
	
	override func setUpWithError() throws {
		
		coordinatorSpy = AppCoordinatorSpy()
		servicesSpies = setupServicesSpies()
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		remoteAuthenticationClientSpy = RemoteAuthenticationClientSpy(serverUrl: url, username: nil, password: nil)
		viewModel = LoginViewModel(coordinator: coordinatorSpy, remoteAuthenticationClient: remoteAuthenticationClientSpy)
		sut = LoginView(viewModel: self.viewModel)
		
		super.setUp()
	}
	
	func test_loginView() {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_loginView_loading() {
		
		// Given
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_loginWithDigiD_shouldCallCoordinator_whenDemoMode() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true

		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "login.digid")
		try view.view(CallToActionButton.self).find(button: "login.digid").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.loggedInWithDigiD
	}
	
	func test_loginWithDigiD_loading_shouldNotCallCoordinator_whenDemoMode() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		viewModel.state = .loading

		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "login.loading")
		try view.view(CallToActionButton.self).find(button: "login.loading").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
	}
}
