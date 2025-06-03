/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Back ported version of PresentationDragIndicator
///  - See: https://developer.apple.com/documentation/swiftui/view/presentationdragindicator(_:)
public struct BackportPresentationDragIndicator: ViewModifier {
	
	/// Visibility (automatic, visible, hidden)
	///  - See: https://developer.apple.com/documentation/swiftui/visibility
	public var visibility: Visibility

	/// Get the view for this modifier
	/// - Parameter content: content
	/// - Returns: View
	public func body(content: Content) -> some View {
		
		if #available(iOS 16.0, *) {
			content
				.presentationDragIndicator(visibility)
		} else {
			content
		}
	}
}

extension View {
	
	/// Back ported version of presentationDragIndicator
	/// - See: https://developer.apple.com/documentation/swiftui/view/presentationdragindicator(_:)
	/// - Parameter visibility: Visibility
	/// - Returns: view with back ported presentationDragIndicator
	public func backportPresentationDragIndicator(_ visibility: Visibility) -> some View {
		modifier(BackportPresentationDragIndicator(visibility: visibility))
	}
}
