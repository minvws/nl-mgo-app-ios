/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Back ported version of scrollContentBackground
/// - See: https://developer.apple.com/documentation/swiftui/view/scrollcontentbackground(_:)
public struct BackportScrollContentBackground: ViewModifier {
	
	/// The visibility
	public var visibility: Visibility
	
	/// Get the view for this modifier
	/// - Parameter content: content
	/// - Returns: view with view modifier
	public func body(content: Content) -> some View {
		
		if #available(iOS 16.0, *) {
			content
				.scrollContentBackground(visibility)
		} else {
			content
		}
	}
}

extension View {
	
	/// Back ported version of scrollContentBackground
	/// - See: https://developer.apple.com/documentation/swiftui/view/scrollcontentbackground(_:)
	/// - Parameter visibility: the visibility
	/// - Returns: view
	public func backportScrollContentBackground(_ visibility: Visibility) -> some View {
		modifier(BackportScrollContentBackground(visibility: visibility))
	}
}
