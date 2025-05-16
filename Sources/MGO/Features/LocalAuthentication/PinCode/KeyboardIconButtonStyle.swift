/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import Theme

struct KeyboardIconButtonStyle: ButtonStyle {

	/// Is the button enabled?
	@Environment(\.isEnabled) private var isEnabled: Bool
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Button {
			static let minimumHeight: CGFloat = 44
			static let fontSize: CGFloat = 30
			static let disabledOpacity: Double = 0.25
			static let cornerRadius: CGFloat = 5
		}
	}
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight, alignment: .center)
			.font(.system(size: ViewTraits.Button.fontSize))
			.foregroundStyle(isEnabled ? theme.contentPrimary : theme.contentPrimary.opacity(ViewTraits.Button.disabledOpacity))
			.background(configuration.isPressed ? theme.backgroundTertiary : theme.backgroundPrimary)
			.cornerRadius(ViewTraits.Button.cornerRadius)
	}
}
