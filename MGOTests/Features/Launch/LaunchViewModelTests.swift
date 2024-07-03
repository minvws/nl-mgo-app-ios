/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class LaunchViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: LaunchViewModel!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
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
		expect(self.servicesSpies.remoteConfigurationRepositorySpy.invokedFetchAndUpdateObservers) == true
	}

	func test_reduce_fromLoadingConfig_toLoadingConfig() {
		
		// Given
		sut.state = .loadingConfig
		
		// When
		sut.reduce(.start)
		
		// Then
		expect(self.sut.state) == .loadingConfig
		expect(self.servicesSpies.remoteConfigurationRepositorySpy.invokedFetchAndUpdateObservers) == false
	}
	
	func test_reduce_fromConfigLoaded_toConfigLoaded() {
		
		// Given
		sut.state = .configLoaded
		
		// When
		sut.reduce(.start)
		
		// Then
		expect(self.sut.state) == .configLoaded
		expect(self.servicesSpies.remoteConfigurationRepositorySpy.invokedFetchAndUpdateObservers) == false
	}
	
	func test_reduce_fromConfigLoaded_toReset() {
		
		// Given
		sut.state = .configLoaded
		
		// When
		sut.reduce(.reset)
		
		// Then
		expect(self.sut.state) == .loadingConfig
		expect(self.servicesSpies.remoteConfigurationRepositorySpy.invokedFetchAndUpdateObservers) == true
	}
	
	func test_loadConfig_shouldCallCoordinator() {
		
		// Given
		sut.state = .idle
		
		// When
		sut.reduce(.loaded)
		
		// Then
		expect(self.sut.state).toEventually(equal(.configLoaded), timeout: .seconds(5))
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.finishedLoading))
	}
}
