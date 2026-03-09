/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FeatureFlag

@MainActor
final class FeatureFlagManagerTests: XCTestCase {

	override func tearDown() {
		super.tearDown()
		FeatureFlagManager().bypassRemoteAuthentication = false
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
		sut.bypassRemoteAuthentication = true

		// When
		sut.wipePersistedData()

		// Then
		expect(sut.bypassRemoteAuthentication) == false
	}
}
