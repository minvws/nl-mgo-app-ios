/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct TypographyViewModifier: ViewModifier {
	
	/// Which typography do we use?
	public var typography: Typography
	
	/// Should we use bold font
	public var isBold: Bool
	
	/// Appy the Rijksoverheid font for typography
	/// - Parameter content: content
	/// - Returns: content with applied font
	public func body(content: Content) -> some View {
		
		content
			.font(
				.RijksoverheidSansWebText
					.relative(
						isBold ? .bold : typography.font(),
						size: typography.textStyle().pointSize2,
						relativeTo: typography.textStyle()
					)
			)
			.lineSpacing(typography.lineSpacing())
	}
}

extension View {
	
	/// Apply the typography to content
	/// - Parameters:
	///   - typography: the typography to use
	///   - isBold: force bold
	/// - Returns: content with typography applied
	public func typography(_ typography: Typography, isBold: Bool = false) -> some View {
		modifier(TypographyViewModifier(typography: typography, isBold: isBold))
	}
}
