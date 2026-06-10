/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OSVersion
import RijksoverheidFont
import SwiftUI
import Theme

struct GlassButtonStyle: ButtonStyle {

	/// The Theme
	@Environment(\.mgoTheme) var theme

	/// Use pill shaped rounded corners?
	var rounded: Bool

	/// Provides OS version checks; injectable so tests can simulate different iOS versions.
	var osVersionChecker: any OSVersionProtocol

	init(rounded: Bool, osVersionChecker: any OSVersionProtocol = OSVersionChecker()) {
		self.rounded = rounded
		self.osVersionChecker = osVersionChecker
	}

	/// Magic Numbers
	private struct ViewTraits {
		enum ButtonTitle {
			static let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
		}
		enum Button {
			static let cornerRadius: CGFloat = 12
			static let roundedRadius: CGFloat = 1000
			static let minimumHeight: CGFloat = 50
			static let opacity: Double = 0.75
		}
	}

	func makeBody(configuration: Self.Configuration) -> some View {
		styledLabel(configuration: configuration)
	}

	@ViewBuilder private func styledLabel(configuration: Self.Configuration) -> some View {
		let radius = rounded ? ViewTraits.Button.roundedRadius : ViewTraits.Button.cornerRadius
		let label = configuration.label
			.typography(.bodyMedium, with: .bold)
			.foregroundColor(theme.actions.tonal.text.opacity(configuration.isPressed ? ViewTraits.Button.opacity : 1))
			.padding(ViewTraits.ButtonTitle.insets)
			.frame(
				maxWidth: .infinity,
				minHeight: ViewTraits.Button.minimumHeight, alignment: .center
			)
			.contentShape(Rectangle())

		if #available(iOS 26, *), osVersionChecker.available(version: .iOS(.v26)) {
			label
				.glassEffect(in: RoundedRectangle(cornerRadius: radius))
		} else {
			label
				.background {
					ZStack {
						Rectangle().fill(.ultraThinMaterial)
						theme.actions.tonal.background.opacity(configuration.isPressed ? ViewTraits.Button.opacity : 1)
					}
					.clipShape(RoundedRectangle(cornerRadius: radius))
				}
		}
	}
}
