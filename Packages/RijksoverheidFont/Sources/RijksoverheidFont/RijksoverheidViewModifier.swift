/*
 * Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

extension Font.TextStyle {
	
	/// The default point size for text styles
	public var pointSize: CGFloat {
		switch self {
			case .largeTitle: 32
			case .title: 28
			case .title2: 26
			case .title3: 24
			case .headline: 17
			case .subheadline: 17
			case .body: 17
			case .callout: 16
			case .footnote: 14
			case .caption: 12
			case .caption2: 12
			@unknown default: 16
		}
	}
}

public struct RijksoverheidViewModifier: ViewModifier {
	public var font: RijksoverheidSansWebTextFont
	public var style: Font.TextStyle
	
	var lineSpacing: CGFloat {
		switch style {
			case .largeTitle: 4
			case .title3: 2
			case .body: 3
			default: 0
		}
	}
	
	public func body(content: Content) -> some View {
		content
			.font(.RijksoverheidSansWebText.relative(font, size: style.pointSize, relativeTo: style))
			.lineSpacing(lineSpacing)
	}
}
