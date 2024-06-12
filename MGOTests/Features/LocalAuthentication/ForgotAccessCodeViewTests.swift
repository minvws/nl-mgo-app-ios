/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class ForgotAccessCodeViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: ForgotAccessCodeView!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		sut = ForgotAccessCodeView(viewModel: ForgotAccessCodeViewModel(coordinator: self.coordinatorSpy))
		super.setUp()
	}

	// MARK: - Actions -
	
	func test_cancel() throws {
		
		// Given
		
		// When
		try sut.inspect().find(viewWithTag: "general_cancel").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.dismissForgotAccessCode
	}
	
	func test_showDialog() throws {
		
		// Given
		
		// When
		try sut.inspect().find(viewWithTag: "forgot_action_reset").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
	}
	
	// MARK: - Snapshots -
	
	func test_forgotAccessCodeView() {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
