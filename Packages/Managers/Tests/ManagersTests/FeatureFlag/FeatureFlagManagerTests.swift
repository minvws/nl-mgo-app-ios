/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import Managers

final class FeatureFlagManagerTests: XCTestCase {

	override func setUp() {
		super.setUp()
		FeatureFlagManager().wipePersistedData()
	}
	
	override func tearDown() {
		super.tearDown()
		FeatureFlagManager().wipePersistedData()
	}
	
	func test_featureFlag_isAutomaticLocalizationEnabled_defaultValue() {

		// Given
		let sut = FeatureFlagManager()
		
		// When
		let result = sut.isAutomaticLocalizationEnabled
		
		// Then
		expect(result) == true
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
		sut.isAutomaticLocalizationEnabled = false
		
		// When
		sut.wipePersistedData()
		
		// Then
		expect(sut.isAutomaticLocalizationEnabled) == true
	}
}
