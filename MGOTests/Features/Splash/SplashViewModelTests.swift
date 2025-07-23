/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class SplashViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: SplashViewModel!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = SplashViewModel(coordinator: coordinatorSpy, state: .idle)
		super.setUp()
	}
	
	func test_init() {
		// Given
		
		// When
		
		// Then
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoad)
			.toEventually(beTrue())
		expect(self.servicesSpies.remoteConfigurationRepositorySpy.invokedFetchAndUpdateObservers)
			.toEventually(beTrue())
	}
	
	@MainActor func test_reduce_fromIdle_toLoadingConfig() {
		
		// Given
		sut.state = .idle
		
		// When
		sut.reduce(.start)
		
		// Then
		expect(self.sut.state) == .idle
		expect(self.servicesSpies.jailBreakSpy.invokedIsJailBroken) == true
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0)
			.toEventually(equal(Coordination.Action.finishedSplash))
	}
	
	@MainActor func test_reduce_fromIdle_toLoadingConfig_jailbroken() throws {
		
		// Given
		sut.state = .idle
		servicesSpies.jailBreakSpy.stubbedIsJailBrokenResult = true
		
		// When
		sut.reduce(.start)
		
		// Then
		expect(self.sut.state) == .idle
		expect(self.sut.showJailBreakDialog) == true
		expect(self.servicesSpies.jailBreakSpy.invokedIsJailBroken) == true
	}

	@MainActor func test_reduce_fromLoadingConfig_toLoadingConfig() {
		
		// Given
		sut.state = .loadingConfig
		
		// When
		sut.reduce(.start)
		
		// Then
		expect(self.sut.state) == .loadingConfig
	}
	
	@MainActor func test_reduce_fromConfigLoaded_toConfigLoaded() {
		
		// Given
		sut.state = .configLoaded
		
		// When
		sut.reduce(.start)
		
		// Then
		expect(self.sut.state) == .configLoaded
	}
	
	@MainActor func test_loadConfig_shouldCallCoordinator() {
		
		// Given
		sut.state = .idle
		
		// When
		sut.reduce(.loaded)
		
		// Then
		expect(self.sut.state)
			.toEventually(equal(.configLoaded), timeout: .seconds(5))
		expect(self.coordinatorSpy.invokedHandle)
			.toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0)
			.toEventually(equal(Coordination.Action.finishedSplash))
	}
	
	@MainActor func test_dissmissWarning_shouldUpdateSecureUserSettings() {
		
		// Given
		sut.state = .idle
		
		// When
		sut.reduce(.dismissWarning)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedUserHasSeenJailBreakWarningSetter)
			.toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandle)
			.toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0)
			.toEventually(equal(Coordination.Action.finishedSplash))
	}
}
