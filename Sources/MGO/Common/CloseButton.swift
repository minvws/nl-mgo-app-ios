/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

/// A simple close button consisting of a cross icon
struct CloseButton: View {
	
	/// The action to execute when the user presses the button
	var action: (() -> Void)?
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let size: CGFloat = 28
		}
	}
	
	/// Initializer
	/// - Parameter action: Optional closure to be executed when the user presses the button
	init(_ action: (() -> Void)?) {
		self.action = action
	}
	
	var body: some View {
		Button(
			action: {
				action?()
			}, label: {
				Image(ImageResource.Icon.close)
					.resizable()
					.frame(width: ViewTraits.Image.size, height: ViewTraits.Image.size)
			}
		)
		.accessibilityLabel("common.close")
		.tag("common.close")
	}
}

#Preview {
	CloseButton(nil)
}
