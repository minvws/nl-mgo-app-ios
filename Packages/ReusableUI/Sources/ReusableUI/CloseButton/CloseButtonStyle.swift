/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct CloseButtonStyle: ButtonStyle {
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let size: CGFloat = 28
		}
	}
	
	/// Style the button to a close button
	/// - Parameter configuration: the button configuration
	/// - Returns: close button
	public func makeBody(configuration: Self.Configuration) -> some View {
		
		Image(configuration.isPressed ? ImageResource.CloseButton.closeHover : ImageResource.CloseButton.close)
			.resizable()
			.frame(width: ViewTraits.Image.size, height: ViewTraits.Image.size)
	}
}
