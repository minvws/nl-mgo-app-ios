/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import DeviceKit

extension Font.TextStyle {
	
	/// The default point size for text styles
	public var pointSize: CGFloat {
		switch self {
			case .largeTitle: isiPhoneSE ? 32 : 34
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
	
	/// Do we run on a very small iPhoneSE ?
	private var isiPhoneSE: Bool {
		Device.current == .iPhoneSE || Device.current == .simulator(.iPhoneSE)
	}
}
