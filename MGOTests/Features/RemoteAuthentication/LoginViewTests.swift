/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class LoginViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var viewModel: LoginViewModel!
	private var sut: LoginView!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		viewModel = LoginViewModel(coordinator: coordinatorSpy)
		sut = LoginView(viewModel: self.viewModel)
		
		super.setUp()
	}
	
	func test_loginView() {
		
		// Given
		viewModel.isEIDASenabled = false
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_loginView_eIDASenabled() {
		
		// Given
		viewModel.isEIDASenabled = true
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_loginWithDigiD_shouldCallCoordinator() throws {
		
		// Given
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "login.digid")
		try view.view(DisclosureWithImageButton.self).find(button: "login.digid").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.loggedInWithDigiD
	}
	
	func test_loginWithEIDAS_shouldCallCoordinator() throws {
		
		// Given
		viewModel.isEIDASenabled = true
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "login.european")
		try view.view(DisclosureWithImageButton.self).find(button: "login.european").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.loggedInWithDigiD
	}
}
