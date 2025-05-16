/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FeatureFlag

final class FeatureFlagManagerTests: XCTestCase {

	override func setUp() {
		super.setUp()
		FeatureFlagManager().isAutomaticLocalizationEnabled = false
		FeatureFlagManager().bypassPincode = false
	}
	
	override func tearDown() {
		super.tearDown()
		FeatureFlagManager().isAutomaticLocalizationEnabled = false
		FeatureFlagManager().bypassPincode = false
	}
	
	func test_featureFlag_isAutomaticLocalizationEnabled_defaultValue() {

		// Given
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.isAutomaticLocalizationEnabled
		
		// Then
		expect(result) == false
	}
	
	func test_featureFlag_isAutomaticLocalizationEnabled_setValue() {
		
		// Given
		FeatureFlagManager().isAutomaticLocalizationEnabled = false
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.isAutomaticLocalizationEnabled
		
		// Then
		expect(result) == false
	}
	
	func test_featureFlag_bypassPincode_defaultValue() {

		// Given
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.bypassPincode
		
		// Then
		expect(result) == false
	}
	
	func test_featureFlag_bypassPincode_setValue() {
		
		// Given
		FeatureFlagManager().bypassPincode = false
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.bypassPincode
		
		// Then
		expect(result) == false
	}

	func test_featureFlag_demo_defaultValue() {

		// Given
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.isDemo
		
		// Then
		expect(result) == false
	}
	
	func test_featureFlag_demo_setValue() {
		
		// Given
		FeatureFlagManager().isDemo = true
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.isDemo
		
		// Then
		expect(result) == false // Demo hardcoded to false
	}
	
	func test_wipePersistedData() {
		
		// Given
		let sut = FeatureFlagManager()
		sut.isAutomaticLocalizationEnabled = true
		sut.bypassPincode = true
		
		// When
		sut.wipePersistedData()
		
		// Then
		expect(sut.isAutomaticLocalizationEnabled) == false
		expect(sut.bypassPincode) == false
	}
}
