/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

final class ForgotPinCodeViewModelTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: ForgotPinCodeViewModel!

	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		sut = ForgotPinCodeViewModel(coordinator: self.coordinatorSpy)
		super.setUp()
	}

	func test_cancelButtonPressed() {
		
		// Given
		
		// When
		sut.reduce(.cancelButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue(), timeout: .seconds(5))
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.dismissForgotPinCode
	}
	
	func test_recreateAccount() {
		
		// Given
		
		// When
		sut.reduce(.recreateAccount)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.recreateAccount
	}
	
	func test_showDialog() {
		
		// Given
		
		// When
		sut.reduce(.showDialog)
		
		// Then
		expect(self.sut.showDialog) == true
	}
	
	func test_cancelDialog() {
		
		// Given
		sut.showDialog = true
		
		// When
		sut.reduce(.cancelDialog)
		
		// Then
		expect(self.sut.showDialog) == false
	}
}
