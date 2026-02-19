/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FeatureFlag

final class FeatureFlagManagerTests: XCTestCase {

//	@MainActor override func setUp() {
//		super.setUp()
//		FeatureFlagManager().isAutomaticLocalizationEnabled = false
//		FeatureFlagManager().bypassRemoteAuthentication = false
//	}
	
	@MainActor override func tearDown() {
		super.tearDown()
		FeatureFlagManager().isAutomaticLocalizationEnabled = false
		FeatureFlagManager().bypassRemoteAuthentication = false
	}
	
	@MainActor func test_featureFlag_isAutomaticLocalizationEnabled_defaultValue() {

		// Given
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.isAutomaticLocalizationEnabled
		
		// Then
		expect(result) == false
	}
	
	@MainActor func test_featureFlag_isAutomaticLocalizationEnabled_setValue() {
		
		// Given
		FeatureFlagManager().isAutomaticLocalizationEnabled = false
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.isAutomaticLocalizationEnabled
		
		// Then
		expect(result) == false
	}
	
	@MainActor func test_featureFlag_bypassRemoteAuthentication_defaultValue() {

		// Given
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.bypassRemoteAuthentication
		
		// Then
		expect(result) == false
	}
	
	@MainActor func test_featureFlag_bypassRemoteAuthentication_setValue() {
		
		// Given
		FeatureFlagManager().bypassRemoteAuthentication = false
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.bypassRemoteAuthentication
		
		// Then
		expect(result) == false
	}

	@MainActor func test_featureFlag_demo_defaultValue() {

		// Given
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.isDemo
		
		// Then
		expect(result) == false
	}
	
	@MainActor func test_featureFlag_demo_setValue() {
		
		// Given
		FeatureFlagManager().isDemo = true
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.isDemo
		
		// Then
		expect(result) == false // Demo hardcoded to false
	}
	
	@MainActor func test_wipePersistedData() {
		
		// Given
		let sut = FeatureFlagManager()
		sut.isAutomaticLocalizationEnabled = true
		sut.bypassRemoteAuthentication = true
		
		// When
		sut.wipePersistedData()
		
		// Then
		expect(sut.isAutomaticLocalizationEnabled) == false
		expect(sut.bypassRemoteAuthentication) == false
	}
}
