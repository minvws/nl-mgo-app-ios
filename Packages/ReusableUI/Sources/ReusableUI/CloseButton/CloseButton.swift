/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// A simple close button consisting of a cross icon
public struct CloseButton: View {
	
	/// The action to execute when the user presses the button
	private var action: (() -> Void)?
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let size: CGFloat = 28
		}
	}
	
	/// Create a close button
	/// - Parameter action: Optional closure to be executed when the user presses the button
	public init(_ action: (() -> Void)?) {
		self.action = action
	}
	
	public var body: some View {
		
		Button {
			action?()
		} label: {
			EmptyView() // Icon is set by the CloseButtonStyle
		}
		.accessibilityLabel("common.close")
		.accessibilityIdentifier("common.close")
	}
}

#Preview {
	CloseButton(nil)
}
