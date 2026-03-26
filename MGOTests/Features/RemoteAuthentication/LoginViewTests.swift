/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
import MGOFoundation
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
		remoteAuthenticationClientSpy = RemoteAuthenticationClientSpy(serverUrl: url)
		
		super.setUp()
	}
	
	@MainActor private func createSut(
		_ mode: LoginViewModel.LoginViewMode
	) {
		
		viewModel = LoginViewModel(
			coordinator: coordinatorSpy,
			mode: mode,
			remoteAuthenticationClient: remoteAuthenticationClientSpy
		)
		sut = LoginView(viewModel: self.viewModel)
	}
	
	@MainActor func test_loginView() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut(.firstTime)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_loginView_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		createSut(.firstTime)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_loginView_repeatVisitor() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut(.repeatVisitor)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_loginView_repeatVisitor_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		createSut(.repeatVisitor)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_loginView_loading() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut(.firstTime)
		viewModel.state = LoginViewModel
			.LoginState(mode: .firstTime, isLoading: true)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_loginView_loading_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		createSut(.firstTime)
		viewModel.state = LoginViewModel
			.LoginState(mode: .firstTime, isLoading: true)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_backbuttonPressed() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut(.firstTime)
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// When
		try content.inspect()
			.find(viewWithAccessibilityIdentifier: "common.previous")
			.button()
			.tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
