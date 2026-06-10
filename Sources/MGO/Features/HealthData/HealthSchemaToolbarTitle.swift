/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import CoreGraphics

/// Decides whether the inline navigation-bar title should be visible.
enum HealthSchemaToolbarTitle {

	/// The toolbar title fades in once the in-content title has scrolled fully
	/// above the top of the scroll view.
	/// - Parameters:
	///   - scrollOffsetY: how far the scroll view has scrolled down.
	///   - titleBlockHeight: measured height of the in-content title block.
	/// - Returns: `true` when the toolbar title should be shown.
	static func shouldShow(scrollOffsetY: CGFloat, titleBlockHeight: CGFloat) -> Bool {
		titleBlockHeight > 0 && scrollOffsetY >= titleBlockHeight
	}
}
