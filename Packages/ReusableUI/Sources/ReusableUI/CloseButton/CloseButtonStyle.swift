/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct CloseButtonStyle: ButtonStyle {
	
	/// Create a close button style
	/// - Parameter small: True if the button should be small  (28px)
	public init(small: Bool = true) { self.small = small }
	
	/// Render as a small button?
	private var small: Bool
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let sizeSmall: CGFloat = 28
			static let sizeLarge: CGFloat = 44
		}
	}
	
	/// Style the button to a close button
	/// - Parameter configuration: the button configuration
	/// - Returns: close button
	public func makeBody(configuration: Self.Configuration) -> some View {
		
		if small {
			Image(configuration.isPressed ? ImageResource.CloseButton.closeHover : ImageResource.CloseButton.close)
				.resizable()
				.frame(
					width: ViewTraits.Image.sizeSmall,
					height: ViewTraits.Image.sizeSmall
				)
		} else {
			Image(
				configuration.isPressed ? ImageResource.CloseButton.closeLargeHover : ImageResource.CloseButton.closeLarge
			)
				.resizable()
				.frame(
					width: ViewTraits.Image.sizeLarge,
					height: ViewTraits.Image.sizeLarge
				)
			
		}
	}
}
