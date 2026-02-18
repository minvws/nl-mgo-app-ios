/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO
import MGOFoundation

final class PropositionViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	@MainActor func createSut() -> PropositionView {
		
		return PropositionView(
			viewModel: PropositionViewModel(
				coordinator: self.coordinatorSpy
			)
		)
	}
	
	@MainActor func test_showProposition() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let sut = createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.98)
	}
	
	@MainActor func test_showProposition_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		let sut = createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.98)
	}
	
	@MainActor func test_nextButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		let sut = createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.next")
		try view.view(CallToActionButton.self).find(button: "common.next").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(
			self.coordinatorSpy.invokedHandleParameters?.0
		) == Coordination.Action.nextButtonPressedOnProposition
	}
	
	@MainActor func test_openPrivacyLink_shouldCallCoordinator() throws {
		
		// Given
		let sut = createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "proposition.open_privacy.button")
		try view.view(CallToActionButton.self).find(button: "proposition.open_privacy.button").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(
			self.coordinatorSpy.invokedHandleParameters?.0
		) == Coordination.Action.showPrivacyStatement
	}
}
