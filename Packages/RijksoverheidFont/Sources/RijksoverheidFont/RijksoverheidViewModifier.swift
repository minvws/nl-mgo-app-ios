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
			case .largeTitle: isiPhoneSE ? 32 : 36
			case .title: isiPhoneSE ? 30 : 34
			case .title2: 26
			case .title3: 24
			case .headline: 18
			case .subheadline: 17
			case .body: 18
			case .callout: 16
			case .footnote: 14
			case .caption: 12
			case .caption2: 12
			@unknown default: 16
		}
	}
	
	/// Do we run on a very small iPhoneSE ?
	private var isiPhoneSE: Bool {
		Device.current == .iPhoneSE || Device.current == .simulator(.iPhoneSE)
	}
}

public struct RijksoverheidViewModifier: ViewModifier {
	
	/// Which Rijksoverheid font to use
	public var font: RijksoverheidSansWebTextFont

	/// What is the text style to use
	public var style: Font.TextStyle
	
	/// What is the point size to use? (if nil, the pointSize of the style (Font.TextStyle) is used
	public var pointSize: CGFloat?
	
	/// The spacing between the lines
	private var lineSpacing: CGFloat {
		switch style {
			case .largeTitle: 4
			case .title: 2
			case .body: 3
			default: 0
		}
	}
	
	public func body(content: Content) -> some View {
		
		if let pointSize {
			content
				.font(.RijksoverheidSansWebText.relative(font, size: pointSize, relativeTo: style))
				.lineSpacing(lineSpacing)
		} else {
			content
				.font(.RijksoverheidSansWebText.relative(font, size: style.pointSize, relativeTo: style))
				.lineSpacing(lineSpacing)
		}
	}
}
