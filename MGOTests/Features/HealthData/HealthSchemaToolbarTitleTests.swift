/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import CoreGraphics
@testable import MGO

struct HealthSchemaToolbarTitleTests {
	
	@Test("Toolbar title stays hidden while the title height is unknown")
	func shouldShow_falseWhenTitleHeightUnknown() {
		
		// Given
		let titleBlockHeight: CGFloat = 0
		let scrollOffsetY: CGFloat = 100
		
		// When
		let shouldShow = HealthSchemaToolbarTitle.shouldShow(
			scrollOffsetY: scrollOffsetY,
			titleBlockHeight: titleBlockHeight
		)
		
		// Then
		#expect(shouldShow == false)
	}
	
	@Test("Toolbar title stays hidden while scrolled less than the title height")
	func shouldShow_falseWhenScrolledLessThanTitleHeight() {
		
		// Given
		let titleBlockHeight: CGFloat = 100
		let scrollOffsetY: CGFloat = 99
		
		// When
		let shouldShow = HealthSchemaToolbarTitle.shouldShow(
			scrollOffsetY: scrollOffsetY,
			titleBlockHeight: titleBlockHeight
		)
		
		// Then
		#expect(shouldShow == false)
	}
	
	@Test("Toolbar title shows once scrolled to or past the title height")
	func shouldShow_trueWhenScrolledPastTitle() {
		
		// Given
		let titleBlockHeight: CGFloat = 100
		
		// When
		
		// Then
		#expect(
			HealthSchemaToolbarTitle.shouldShow(
				scrollOffsetY: 100,
				titleBlockHeight: titleBlockHeight
			)
		)
		#expect(
			HealthSchemaToolbarTitle.shouldShow(
				scrollOffsetY: 150,
				titleBlockHeight: titleBlockHeight
			)
		)
	}
}
