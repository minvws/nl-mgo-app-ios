/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class PropositionViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	func createSut() -> PropositionView {
		
		return PropositionView(
			viewModel: PropositionViewModel(
				coordinator: self.coordinatorSpy
			)
		)
	}
	
	func test_showProposition() {
		
		// Given
		let sut = createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_handleURL_validlink() throws {
		
		// Given
		let sut = createSut()
		
		// When
		let element = try sut.inspect().find(viewWithAccessibilityIdentifier: "proposition.subheading")
		try element.callOnTapGesture()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showPrivacyStatement
	}
	
	func test_nextButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		let sut = createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.next")
		try view.view(CallToActionButton.self).find(button: "common.next").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.nextButtonPressedOnProposition
	}
}
