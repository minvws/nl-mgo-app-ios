/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO
import MGOUI

final class AboutSafetyTipsViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: AboutSafetyTipsView!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	@MainActor private func createSut() {
		
		sut = AboutSafetyTipsView(
			viewModel: BaseViewModel(
				coordinator: self.coordinatorSpy
			)
		)
	}
	
	@MainActor func test_aboutSafetyTipsView() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_backbuttonPressed() throws {
		
		// Given
		createSut()
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
