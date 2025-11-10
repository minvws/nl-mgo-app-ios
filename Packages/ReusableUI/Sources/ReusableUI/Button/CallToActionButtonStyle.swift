/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// All possible styles for CallToActionButton
public enum CallToActionButtonStyle: Equatable {
	case primaryWithLeadingIcon
	case primaryWithLeadingSpinner
	case solid(rounded: Bool)
	case tonal(rounded: Bool)
	case ghost
	case withIcon
	case withSpinner
	
	public static func == (lhs: CallToActionButtonStyle, rhs: CallToActionButtonStyle) -> Bool {
		switch (lhs, rhs) {
			case (.primaryWithLeadingIcon, .primaryWithLeadingIcon),
				(.primaryWithLeadingSpinner, .primaryWithLeadingSpinner),
				(.ghost, .ghost),
				(.withIcon, .withIcon),
				(.withSpinner, .withSpinner):
				return true
			case let (.solid(left), .solid(right)):
				return left == right
			case let (.tonal(left), .tonal(right)):
				return left == right
			default:
				return false
		}
	}
}
