/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class AppDelegateTests: XCTestCase {
	
	private var sut: AppDelegate!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		sut = AppDelegate()
	}
	
	func test_onWillResignActiveNotification() {
		
		// Given
		
		// When
		sut.onWillResignActiveNotification()
		
		// Then
		expect(self.sut.privacySnapshotWindow) != nil
		expect(self.servicesSpies.secureUserSettingsSpy.invokedEnteredBackgroundSetterCount) == 1
	}
	
	func test_onWillResignActiveNotification_withDate() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedEnteredBackground = Date()
		
		// When
		sut.onWillResignActiveNotification()
		
		// Then
		expect(self.sut.privacySnapshotWindow) != nil
		expect(self.servicesSpies.secureUserSettingsSpy.invokedEnteredBackgroundGetterCount) == 1
		expect(self.servicesSpies.secureUserSettingsSpy.invokedEnteredBackgroundSetterCount) == 0
	}
	
	func test_onDidBecomeActiveNotification () {
		
		// Given
		
		// When
		sut.onDidBecomeActiveNotification()
		
		// Then
		expect(self.sut.privacySnapshotWindow) == nil
	}
	
	func test_onDidBecomeActiveNotification_longInBackground_shouldPostNotification() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedEnteredBackground = Date().addingTimeInterval(-150)
		
		// When
		sut.onDidBecomeActiveNotification()
		
		// Then
		expect(self.sut.privacySnapshotWindow) == nil
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
		expect(self.servicesSpies.secureUserSettingsSpy.enteredBackground) != nil
	}
	
	func test_onDidBecomeActiveNotification_shortInBackground_shouldReset() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedEnteredBackground = Date().addingTimeInterval(-1)
		
		// When
		sut.onDidBecomeActiveNotification()
		
		// Then
		expect(self.sut.privacySnapshotWindow) == nil
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == false
		expect(self.servicesSpies.secureUserSettingsSpy.invokedEnteredBackground) == nil
		expect(self.servicesSpies.secureUserSettingsSpy.invokedEnteredBackgroundSetter) == true
	}
}
