/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

final class ForgotAccessCodeViewModelTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: ForgotAccessCodeViewModel!

	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		sut = ForgotAccessCodeViewModel(coordinator: self.coordinatorSpy)
		super.setUp()
	}

	func test_cancelButtonPressed() {
		
		// Given
		
		// When
		sut.reduce(.cancelButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.dismissForgotAccessCode
	}
	
	func test_loginWithDigiD() {
		
		// Given
		
		// When
		sut.reduce(.loginWithDigiD)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.remoteAuthentication
	}
}
