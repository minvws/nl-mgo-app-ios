/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

public struct ToastView: View {
	
	/// The Banner to display
	public var feedback: Feedback
	
	/// Should we use the rounded corners as of iOS 26?
	public var rounded: Bool
	
	/// The action to be performed when the user presses this card
	public var closeAction: (() -> Void)?
	
	/// Initializer
	/// - Parameters:
	///   - feedback: the banner to display
	///   - perform: The action to perform when the user presses on the close button
	public init(
		_ feedback: Feedback,
		rounded: Bool,
		closeAction: (() -> Void)? = nil) {
			self.feedback = feedback
			self.rounded = rounded
			self.closeAction = closeAction
		}
	
	/// has the user pressed (but no released) the close button
	@State private var onCloseHover = false
	
	/// The background color for the toast
	var backgroundColor: Color {
		switch feedback.type {
			case .info:
				theme.states.informative
			case .warning:
				theme.states.warning
			case .error:
				theme.states.critical
			case .success:
				theme.states.positive
		}
	}
	
	var foregroundColor: Color {
		switch feedback.type {
			case .info, .error, .success:
				theme.backgrounds.secondary
			case .warning:
			// Different color for orange, white on orange is not accessible.
				colorScheme == .light ?	theme.labels.primary : theme.backgrounds.secondary
		}
	}
	
	/// The Theme
	@Environment(\.theme) private var theme
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Toast {
			static let spacing: CGFloat = 8
			static let padding: CGFloat = 16
			static let cornerRadius: CGFloat = 12
			static let roundedRadius: CGFloat = 1000
		}
		enum Button {
			static let size: CGFloat = 40
			static let offset: CGFloat = 12
		}
	}
	
	public var body: some View {
		
		HStack(spacing: ViewTraits.Toast.spacing, content: {
			
			VStack {
				
				// Toast type icon
				
				switch feedback.type {
					case .info:
						Image(ImageResource.Toast.info)
							.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_info", value: nil, table: "Feedback"))
					case .warning:
						Image(ImageResource.Toast.warning)
							.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_warning", value: nil, table: "Banner"))
					case .error:
						Image(ImageResource.Toast.error)
							.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_error", value: nil, table: "Feedback"))
					case .success:
						Image(ImageResource.Toast.checked)
							.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_success", value: nil, table: "Feedback"))
				}
			}
			.accessibilitySortPriority(1000)
			.accessibilityRemoveTraits(.isImage)
			
			HStack {
				
				// Heading
				
				Text(feedback.heading)
					.foregroundStyle(foregroundColor)
					.accessibilitySortPriority(990)
					.accessibilityIdentifier("toast.heading")
					.padding(.vertical, ViewTraits.Toast.padding)
				
				Spacer()
				
				// Action
	
				Button(action: {
					feedback.action?()
				}, label: {
					Text(feedback.subheading)
						.underline(color: foregroundColor)
						.foregroundStyle(foregroundColor)
				})
				.layoutPriority(100)
				.padding(.vertical, ViewTraits.Toast.padding)
				.buttonStyle(ToastButtonStyle())
				.accessibilitySortPriority(980)
				.accessibilityIdentifier("toast.subheading")
			}
			.typography(.bodyMedium)
			
			// Close Button
			
			Button(action: {
				closeAction?()
			}, label: {
				Image(ImageResource.Toast.close)
					.foregroundStyle(foregroundColor)
			})
			.padding(.vertical, ViewTraits.Toast.padding)
			.buttonStyle(ToastButtonStyle())
			.accessibilitySortPriority(970)
			.accessibilityIdentifier("toast.close")
			.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_close", value: nil, table: "Feedback"))
		})
		.padding(.horizontal, ViewTraits.Toast.padding)
		.frame(maxWidth: .infinity)
		.background(backgroundColor)
		.clipShape(
			RoundedRectangle(cornerRadius: rounded ? ViewTraits.Toast.roundedRadius : ViewTraits.Toast.cornerRadius)
		)
	}
}

#Preview {
	VStack {
		ToastView(Feedback(title: "Title", subtitle: "Text", type: .info), rounded: true)
		ToastView(Feedback(title: "Title", subtitle: "Text", type: .warning), rounded: true)
		ToastView(Feedback(title: "Title", subtitle: "Text", type: .error), rounded: true)
		ToastView(Feedback(title: "Title", subtitle: "Text", type: .success), rounded: true)
	}
	.padding(16)
}
