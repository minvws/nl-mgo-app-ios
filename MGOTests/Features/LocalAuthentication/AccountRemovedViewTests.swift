/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class AccountRemovedViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var viewModel: AccountRemovedViewModel!
	private var servicesSpies: ServicesSpies!
	private var sut: AccountRemovedView!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	@MainActor private func createSut() {
		
		viewModel = AccountRemovedViewModel(coordinator: coordinatorSpy)
		sut = AccountRemovedView(viewModel: self.viewModel)
	}
	
	@MainActor func test_accountRemovedView() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_accountRemovedView_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_actionRestart_shouldCallCoordinator() throws {
		
		// Given
		createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "account_removed.action")
		try view.view(CallToActionButton.self).find(button: "account_removed.action").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.restart
	}
}
