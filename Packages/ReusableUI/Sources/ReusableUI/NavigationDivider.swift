/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct NavigationDivider: View {
	
	/// Create a Navigation Divider
	public init() { /* empty init */ }
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Divider {
			static let height: CGFloat = 0.33
			static let opacity: Double = 0.15
		}
	}
	
	public var body: some View {
		Divider()
			.frame(height: ViewTraits.Divider.height)
			.frame(maxWidth: .infinity)
			.overlay(theme.contentPrimary.opacity(ViewTraits.Divider.opacity))
	}
}
