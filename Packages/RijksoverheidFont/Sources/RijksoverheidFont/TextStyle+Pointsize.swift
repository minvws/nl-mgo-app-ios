/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import DeviceKit

extension Font.TextStyle {
	
	/// The base point size used for this text style in the Rijksoverheid design system.
	///
	/// These are fixed design-token values, not the Dynamic Type sizes provided
	/// by the system.  They are passed to ``Font/RijksoverheidSansWebText/relative(_:relativeTo:)``
	/// as the base size; Dynamic Type scaling is still applied through
	/// `Font.custom(_:size:relativeTo:)` and the UIKit variable-font path.
	///
	/// Two styles are reduced on the original iPhone SE to prevent text from
	/// overflowing its layout bounds on the narrower screen:
	///
	/// | Style        | Default | iPhone SE |
	/// |--------------|---------|-----------|
	/// | `.largeTitle`| 34 pt   | 30 pt     |
	/// | `.title`     | 28 pt   | 26 pt     |
	public var pointSize: CGFloat {
		switch self {
			case .largeTitle: isiPhoneSE ? 30 : 34
			case .title: isiPhoneSE ? 26 : 28
			case .title2: 22
			case .title3: 20
			case .headline: 20
			case .subheadline: 18
			case .body: 18
			case .callout: 16
			case .footnote: 14
			case .caption: 12
			case .caption2: 12
			@unknown default: 18
		}
	}
	
	/// Returns `true` when the app is running on the original iPhone SE (4-inch screen).
	private var isiPhoneSE: Bool {
		Device.current == .iPhoneSE || Device.current == .simulator(.iPhoneSE)
	}
}
