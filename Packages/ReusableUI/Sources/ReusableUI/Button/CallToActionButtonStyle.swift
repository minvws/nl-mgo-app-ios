/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// All possible styles for CallToActionButton
public enum CallToActionButtonStyle: Equatable {
	
	case ghost
	case solidLeadingIcon(rounded: Bool)
	case solidLeadingSpinner(rounded: Bool)
	case solid(rounded: Bool, narrow: Bool)
	case tonal(rounded: Bool)
	case withIcon
	case withSpinner
	
	public static func == (lhs: CallToActionButtonStyle, rhs: CallToActionButtonStyle) -> Bool {
		switch (lhs, rhs) {
			case (.ghost, .ghost),
				(.withIcon, .withIcon),
				(.withSpinner, .withSpinner):
				return true
			case let (.solidLeadingIcon(left), .solidLeadingIcon(right)):
				return left == right
			case let (.solidLeadingSpinner(left), .solidLeadingSpinner(right)):
				return left == right
			case let (.solid(lhsRounded, lhsSize), .solid(rhsRounded, rhsSize)):
				return lhsRounded == rhsRounded && lhsSize == rhsSize
			case let (.tonal(left), .tonal(right)):
				return left == right
			default:
				return false
		}
	}
}
