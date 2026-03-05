/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGO
import Testing

@MainActor
final class SplashViewModelTests {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: SplashViewModel!
	private var servicesSpies: ServicesSpies!
	
	init() async throws {
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = SplashViewModel(coordinator: coordinatorSpy, state: .idle)
	}
	
	@Test func reduce_fromIdle_toLoadingConfig() async throws {
		
		// Given
		sut.state = .idle
		servicesSpies.secureUserSettingsSpy.invokedUserHasSeenJailBreakWarning = false
		
		// When
		sut.reduce(.start)
		
		// Then
		#expect(servicesSpies.jailBreakSpy.invokedIsJailBroken == true)
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.finishedSplash)
	}
	
	@Test func reduce_fromIdle_toLoadingConfig_jailbroken() {
		
		// Given
		sut.state = .idle
		servicesSpies.secureUserSettingsSpy.stubbedUserHasSeenJailBreakWarning = false
		servicesSpies.jailBreakSpy.stubbedIsJailBrokenResult = true
		
		// When
		sut.reduce(.start)
		
		// Then
		#expect(servicesSpies.jailBreakSpy.invokedIsJailBroken == true)
		#expect(coordinatorSpy.invokedHandle == false)
		#expect(sut.state == .idle)
		#expect(sut.showJailBreakDialog == true)
	}
	
	@Test func reduce_fromIdle_toLoadingConfig_jailbroken_alreadySeenWarning() {
		
		// Given
		sut.state = .idle
		servicesSpies.secureUserSettingsSpy.stubbedUserHasSeenJailBreakWarning = true
		servicesSpies.jailBreakSpy.stubbedIsJailBrokenResult = true
		
		// When
		sut.reduce(.start)
		
		// Then
		#expect(sut.state == .idle)
		#expect(servicesSpies.jailBreakSpy.invokedIsJailBroken == false)
		#expect(sut.showJailBreakDialog == false)
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.finishedSplash)
	}
	
	@Test func reduce_fromLoadingConfig_toLoadingConfig() async throws {
		
		// Given
		sut.state = .loadingConfig
		
		// When
		sut.reduce(.start)
		
		// Then
		#expect(sut.state == .loadingConfig)
	}
	
	@Test func reduce_fromConfigLoaded_toConfigLoaded() async throws {
		
		// Given
		sut.state = .configLoaded
		
		// When
		sut.reduce(.start)
		
		// Then
		#expect(sut.state == .configLoaded)
	}
	
	@Test func reduce_loadConfig_shouldCallCoordinator() async throws {
		
		// Given
		sut.state = .idle
		
		// When
		sut.reduce(.loaded)
		
		// Then
		#expect(sut.state == .configLoaded)
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.finishedSplash)
	}
	
	@Test func reduce_dismissWarning_shouldUpdateSecureUserSettings() async throws {
		
		// Given
		sut.state = .idle
		
		// When
		sut.reduce(.dismissWarning)
		
		// Then
		#expect(servicesSpies.secureUserSettingsSpy.invokedUserHasSeenJailBreakWarningSetter == true)
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.finishedSplash)
	}
	
	@Test func startServices_shouldCallAllThreeServices() async throws {
		
		// Given
		// Called upon initialization
		
		// When
		// The Task in startServices() contains 3 sequential awaits, each of which
		// hops off and back to the main actor. Yield enough times to let all
		// suspension points (task start + 2 hops per await) complete.
		for _ in 0..<10 {
			await Task.yield()
		}
		
		// Then
		#expect(servicesSpies.remoteConfigurationRepositorySpy.invokedFetchAndUpdateObservers == true)
		#expect(servicesSpies.patientFriendlyTermsRepositorySpy.invokedFetchTerms == true)
		#expect(servicesSpies.searchOrganizationClientSpy.invokedPrepare == true)
		#expect(servicesSpies.searchOrganizationClientSpy.invokedPrepareParameters?.dataset == .medmij)
	}
}
