/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

final class AccountRemovedViewModelTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: AccountRemovedViewModel!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = AccountRemovedViewModel(coordinator: coordinatorSpy)
		super.setUp()
	}
	
	func test_actionRestart_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.restart)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.restart
	}
}
