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
	public var perform: (() -> Void)?
	
	/// Initializer
	/// - Parameters:
	///   - feedback: the banner to display
	///   - perform: The action to perform when the user presses on the close button
	public init(
		_ feedback: Feedback,
		perform: (() -> Void)? = nil) {
		self.feedback = feedback
		self.perform = perform
	}
	
	/// has the user pressed (but no released) the button
	@State private var onHover = false
	
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
				theme.actionPrimaryText
			case .warning:
				theme.contentPrimary
		}
	}
	
	/// The Theme
	@Environment(\.theme) private var theme
	
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
							switch feedback.type {
								case .info:
									Image(ImageResource.Toast.info)
			//						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_info", value: nil, table: "Banner"))
								case .warning:
									Image(ImageResource.Toast.warning)
			//						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_warning", value: nil, table: "Banner"))
								case .error:
									Image(ImageResource.Toast.error)
			//						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_error", value: nil, table: "Banner"))
								case .success:
									Image(ImageResource.Toast.checked)
			//						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_success", value: nil, table: "Banner"))
							}
						}
			//				.accessibilitySortPriority(1000)
							.accessibilityRemoveTraits(.isImage)
			
			HStack {
				Text(feedback.heading)
					.layoutPriority(1)
				Spacer()
				Text(feedback.subheading)
					.underline(color: foregroundColor)
					.layoutPriority(2)
					._onButtonGesture { _ in
//						self.onHover = pressed
					} perform: {
						feedback.action?()
					}
			}
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundStyle(foregroundColor)
			
			Image(ImageResource.Toast.close)
//				.frame(width: ViewTraits.Button.size, height: ViewTraits.Button.size)
//				.offset(x: ViewTraits.Button.offset, y: -ViewTraits.Button.offset)
				._onButtonGesture { pressed in
					self.onHover = pressed
				} perform: {
					perform?()
				}
			
		})
		.padding(ViewTraits.Toast.padding)
		.frame(maxWidth: .infinity)
		.background(backgroundColor)
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.Toast.cornerRadius))

		
//		HStack(alignment: .top, spacing: ViewTraits.Banner.spacing) {
//			Group {
//				switch feedback.type {
//					case .info:
//						Image(ImageResource.Banner.info)
//						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_info", value: nil, table: "Banner"))
//					case .warning:
//						Image(ImageResource.Banner.warning)
//						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_warning", value: nil, table: "Banner"))
//					case .error:
//						Image(ImageResource.Banner.error)
//						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_error", value: nil, table: "Banner"))
//					case .success:
//						Image(ImageResource.Banner.checked)
//						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_success", value: nil, table: "Banner"))
//				}
//			}
//				.accessibilitySortPriority(1000)
//				.accessibilityRemoveTraits(.isImage)
//			
//			VStack(alignment: .leading, spacing: ViewTraits.Banner.innerSpacing) {
//				
//				Text(feedback.heading)
//					.rijksoverheidStyle(font: .bold, style: .body)
//					.foregroundColor(theme.contentPrimary)
//					.accessibilityAddTraits(.isHeader)
//					.accessibilitySortPriority(990)
//					.accessibilityIdentifier("banner.heading")
//				
//				Text(feedback.subheading)
//					.rijksoverheidStyle(font: .regular, style: .body)
//					.foregroundColor(theme.contentTertiary)
//					.accessibilitySortPriority(980)
//					.accessibilityIdentifier("banner.subheading")
//			}
//			.frame(maxWidth: .infinity, alignment: .leading)
//			.fixedSize(horizontal: false, vertical: true)
//			
//			Image(ImageResource.Banner.close)
//				.frame(width: ViewTraits.Button.size, height: ViewTraits.Button.size)
//				.offset(x: ViewTraits.Button.offset, y: -ViewTraits.Button.offset)
//				._onButtonGesture { pressed in
//					self.onHover = pressed
//				} perform: {
//					perform?()
//				}
//				.foregroundColor(onHover ? theme.iconsPrimary : theme.iconsSecondary)
//				.accessibilitySortPriority(970)
//				.accessibilityRemoveTraits(.isImage)
//				.accessibilityAddTraits(.isButton)
//				.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_close", value: nil, table: "Banner"))
//				.accessibilityIdentifier("banner.close")
//			
//		}
//		.cardify(padding: ViewTraits.Banner.padding, lineColor: theme.linesSecondary)
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

public struct ToastModifier: ViewModifier {
	
	var feedback: Feedback?
	
	var closeAction: (() -> Void)?
	
	public func body(content: Content) -> some View {
		if let feedback {
			content
				.overlay(alignment: .bottom) {
					ToastView(feedback) {
						withAnimation {
							closeAction?()
						}
					}
					.padding(16)
				}
		} else {
			content
		}
	}
}

extension View {
	
	public func toast(_ feedback: Feedback?, closeAction: (() -> Void)?) -> some View {
		modifier(ToastModifier(feedback: feedback, closeAction: closeAction))
	}
}

//
//#Preview {
//	Text("Hello, world!")
//		.modifier(MyModifier())
//}
