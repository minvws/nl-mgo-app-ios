/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue(), timeout: .seconds(5))
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.restart
	}
}
