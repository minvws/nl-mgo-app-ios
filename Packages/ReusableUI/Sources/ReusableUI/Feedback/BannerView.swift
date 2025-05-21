/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

public struct BannerView: View {
	
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
	
	/// The Theme
	@Environment(\.theme) private var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Banner {
			static let spacing: CGFloat = 12
			static let padding: CGFloat = 12
			static let innerSpacing: CGFloat = 4
		}
		enum Button {
			static let size: CGFloat = 40
			static let offset: CGFloat = 12
		}
	}
	
	public var body: some View {
		
		HStack(alignment: .top, spacing: ViewTraits.Banner.spacing) {
			VStack {
				switch feedback.type {
					case .info:
						Image(ImageResource.Banner.info)
						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_info", value: nil, table: "Feedback"))
					case .warning:
						Image(ImageResource.Banner.warning)
						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_warning", value: nil, table: "Feedback"))
					case .error:
						Image(ImageResource.Banner.error)
						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_error", value: nil, table: "Feedback"))
					case .success:
						Image(ImageResource.Banner.checked)
						.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_success", value: nil, table: "Feedback"))
				}
			}
				.accessibilitySortPriority(1000)
				.accessibilityRemoveTraits(.isImage)
			
			VStack(alignment: .leading, spacing: ViewTraits.Banner.innerSpacing) {
				
				Text(feedback.heading)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundColor(theme.contentPrimary)
					.accessibilityAddTraits(.isHeader)
					.accessibilitySortPriority(990)
					.accessibilityIdentifier("banner.heading")
				
				Text(feedback.subheading)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundColor(theme.contentSecondary)
					.accessibilitySortPriority(980)
					.accessibilityIdentifier("banner.subheading")
				
				if let actionTitle = feedback.actionTitle {
					Button(actionTitle) {
						feedback.action?()
					}
					.buttonStyle(LinkButtonStyle())
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.fixedSize(horizontal: false, vertical: true)
			
			Image(ImageResource.Banner.close)
				.frame(width: ViewTraits.Button.size, height: ViewTraits.Button.size)
				.offset(x: ViewTraits.Button.offset, y: -ViewTraits.Button.offset)
				._onButtonGesture { pressed in
					self.onHover = pressed
				} perform: {
					perform?()
				}
				.foregroundColor(onHover ? theme.symbolPrimary : theme.symbolSecondary)
				.accessibilitySortPriority(970)
				.accessibilityRemoveTraits(.isImage)
				.accessibilityAddTraits(.isButton)
				.accessibilityLabel(Bundle.module.localizedString(forKey: "banner_close", value: nil, table: "Banner"))
				.accessibilityIdentifier("banner.close")
			
		}
		.cardify(padding: ViewTraits.Banner.padding, lineColor: theme.borderSecondary)
	}
}

#Preview {
	VStack {
		BannerView(Feedback(title: "Title", subtitle: "Text", type: .info))
			.cardify(lineColor: .black)
		BannerView(Feedback(title: "Title", subtitle: "Text", type: .warning))
			.cardify(lineColor: .black)
		BannerView(Feedback(title: "Title", subtitle: "Text", type: .error))
			.cardify(lineColor: .black)
		BannerView(Feedback(title: "Title", subtitle: "Text", actionTitle: "Click me!", type: .success))
			.cardify(lineColor: .black)
	}
	.padding(.vertical, 20)
	.padding(.horizontal, 16)
}
