/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

public struct ToastView: View {
	
	/// The Banner to display
	public var feedback: Feedback
	
	/// The action to be performed when the user presses this card
	public var closeAction: (() -> Void)?
	
	/// Initializer
	/// - Parameters:
	///   - feedback: the banner to display
	///   - perform: The action to perform when the user presses on the close button
	public init(
		_ feedback: Feedback,
		closeAction: (() -> Void)? = nil) {
			self.feedback = feedback
			self.closeAction = closeAction
		}
	
	/// has the user pressed (but no released) the close button
	@State private var onCloseHover = false
	
	/// has the user pressed (but no released) the action button
	@State private var onActionHover = false
	
	/// The background color for the toast
	var backgroundColor: Color {
		switch feedback.type {
			case .info:
				theme.notificationInformation
			case .warning:
				theme.notificationWarning
			case .error:
				theme.notificationError
			case .success:
				theme.notificationSuccess
		}
	}
	
	var foregroundColor: Color {
		switch feedback.type {
			case .info, .error, .success:
				theme.backgroundSecondary
			case .warning:
			// Different color for orange, white on orange is not accessible.
				colorScheme == .light ?	theme.contentPrimary : theme.backgroundSecondary
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
			static let cornerRadius: CGFloat = 8
		}
		enum Button {
			static let size: CGFloat = 40
			static let offset: CGFloat = 12
		}
	}
	
	public var body: some View {
		
		HStack(spacing: ViewTraits.Toast.spacing, content: {
			
			Group {
				
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
					.layoutPriority(1)
					.foregroundStyle(foregroundColor)
					.accessibilitySortPriority(990)
					.accessibilityIdentifier("toast.heading")
				
				Spacer()
				
				// Action
				
				Text(feedback.subheading)
					.underline(color: foregroundColor)
					.foregroundStyle(foregroundColor).opacity(onActionHover ? 0.5 : 1)
					.layoutPriority(2)
					.padding(.vertical, ViewTraits.Toast.padding)
					._onButtonGesture { pressed in
						self.onActionHover = pressed
					} perform: {
						feedback.action?()
					}
					.accessibilityRemoveTraits(.isStaticText)
					.accessibilityAddTraits(.isButton)
					.accessibilitySortPriority(980)
					.accessibilityIdentifier("toast.subheading")
			}
			.rijksoverheidStyle(font: .regular, style: .body)
			
			// Close Button
			
			Image(ImageResource.Toast.close)
				._onButtonGesture { pressed in
					self.onCloseHover = pressed
				} perform: {
					closeAction?()
				}
				.foregroundStyle(foregroundColor).opacity(onCloseHover ? 0.5 : 1)
				.padding(.vertical, ViewTraits.Toast.padding)
				.accessibilityRemoveTraits(.isImage)
				.accessibilityAddTraits(.isButton)
				.accessibilitySortPriority(970)
				.accessibilityIdentifier("toast.close")
		})
		.frame(maxWidth: .infinity)
		.background(backgroundColor)
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.Toast.cornerRadius))
	}
}

#Preview {
	VStack {
		ToastView(Feedback(title: "Title", subtitle: "Text", type: .info))
		ToastView(Feedback(title: "Title", subtitle: "Text", type: .warning))
		ToastView(Feedback(title: "Title", subtitle: "Text", type: .error))
		ToastView(Feedback(title: "Title", subtitle: "Text", type: .success))
	}
}
