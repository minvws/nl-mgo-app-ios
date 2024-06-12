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
	
	/// The Toast to display
	public var toast: Toast
	
	/// The action to be performed when the user presses this card
	public var perform: (() -> Void)?
	
	/// Initializer
	/// - Parameters:
	///   - toast: the toast to display
	///   - perform: The action to perform when the user presses on the close button
	public init(
		_ toast: Toast,
		perform: (() -> Void)? = nil) {
		self.toast = toast
		self.perform = perform
	}
	
	/// has the user pressed (but no released) the button
	@State private var onHover = false
	
	/// The Theme
	@Environment(\.theme) private var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Toast {
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
		
		HStack(alignment: .top, spacing: ViewTraits.Toast.spacing) {
			
			switch toast.type {
				case .info:
					Image(ImageResource.Toast.info)
				case .warning:
					Image(ImageResource.Toast.warning)
				case .error:
					Image(ImageResource.Toast.error)
				case .success:
					Image(ImageResource.Toast.checked)
			}
			
			VStack(alignment: .leading, spacing: ViewTraits.Toast.innerSpacing) {
				
				Text(toast.title)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundColor(theme.contentPrimary)
					.accessibilityAddTraits(.isHeader)
				
				Text(toast.subtitle)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundColor(theme.contentTertiary)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			
			Image(ImageResource.Toast.close)
				.frame(width: ViewTraits.Button.size, height: ViewTraits.Button.size)
				.offset(x: ViewTraits.Button.offset, y: -ViewTraits.Button.offset)
				._onButtonGesture { pressed in
					self.onHover = pressed
				} perform: {
					perform?()
				}
				.foregroundColor(onHover ? theme.iconsPrimary : theme.iconsSecondary)
			
		}
		.cardify(padding: ViewTraits.Toast.padding, lineColor: theme.linesSecondary)
    }
}

#Preview {
	VStack {
		ToastView(Toast(title: "Title", subtitle: "Text", type: .info))
		ToastView(Toast(title: "Title", subtitle: "Text", type: .warning))
		ToastView(Toast(title: "Title", subtitle: "Text", type: .error))
		ToastView(Toast(title: "Title", subtitle: "Text", type: .success))
	}
}
