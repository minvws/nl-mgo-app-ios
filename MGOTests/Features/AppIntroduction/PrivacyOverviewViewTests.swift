/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class PrivacyOverviewViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	func createSut() -> PrivacyOverviewView {
		
		return PrivacyOverviewView(
			viewModel: PrivacyOverviewViewModel(
				coordinator: self.coordinatorSpy
			)
		)
	}
	
	func test_showPrivacyOverviewView() {
		
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
		let element = try sut.inspect().find(viewWithTag: "privacylink")
		try element.callOnTapGesture()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showPrivacyStatement
	}
}
