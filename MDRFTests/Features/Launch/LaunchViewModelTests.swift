/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzTest
@testable import MDRF

final class LaunchViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: LaunchViewModel!
	
	override func setUp() {
		
		coordinatorSpy = AppCoordinatorSpy()
		sut = LaunchViewModel(coordinator: coordinatorSpy, state: .idle)
		super.setUp()
	}
	
	func test_reduce_fromIdle_toLoadingConfig() {
		
		// Given
		sut.state = .idle
		
		// When
		sut.reduce(.start)
		
		// Then
		expect(self.sut.state) == .loadingConfig
	}

	func test_reduce_fromLoadingConfig_toLoadingConfig() {
		
		// Given
		sut.state = .loadingConfig
		
		// When
		sut.reduce(.start)
		
		// Then
		expect(self.sut.state) == .loadingConfig
	}
	
	func test_reduce_fromConfigLoaded_toConfigLoaded() {
		
		// Given
		sut.state = .configLoaded
		
		// When
		sut.reduce(.start)
		
		// Then
		expect(self.sut.state) == .configLoaded
	}
	
	func test_loadConfig_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.loadConfig(0.1)
		
		// Then
		expect(self.sut.state).toEventually(equal(.configLoaded))
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(AppCoordination.Action.finishedLoading))
	}
}
