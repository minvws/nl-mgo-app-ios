/*
 *  SPDX-FileCopyrightText: 2019 Alexey
 *  SPDX-License-Identifier: MIT
 */

import SwiftUI

// See https://github.com/nalexn/ViewInspector/blob/0.10.3/guide_popups.md#fullscreencover
public extension View {
	
	/// Create an inspectable full screen cover.
	/// - Parameters:
	///   - isPresented: A binding to a Boolean value that determines whether
	///     to present the full screen cover. that you create in the modifier's `content` closure.
	///   - onDismiss: The closure to execute when dismissing the full screen cover..
	///   - content: A closure that returns the content of the full screen cover..
	/// - Returns: inspectable full screen cover.
	func inspectableFullScreenCover<FullScreenCover>(
		isPresented: Binding<Bool>,
		onDismiss: (() -> Void)? = nil,
		@ViewBuilder content: @escaping () -> FullScreenCover
	) -> some View where FullScreenCover: View {
		
		return self.modifier(
			InspectableFullScreenCover(
				isPresented: isPresented,
				onDismiss: onDismiss,
				popupBuilder: content
			)
		)
	}
}

public struct InspectableFullScreenCover<FullScreenCover>: ViewModifier where FullScreenCover: View {
	
	/// A binding to a Boolean value that determines whether
	/// to present the full screen cover. that you create in the modifier's
	public let isPresented: Binding<Bool>

	/// The closure to execute when dismissing the full screen cover..
	public let onDismiss: (() -> Void)?

	/// A closure that returns the content of the full screen cover.
	public let popupBuilder: () -> FullScreenCover
	
	/// Get the view for this modifier
	/// - Parameter content: Content
	/// - Returns: modified View
	public func body(content: Self.Content) -> some View {
		
		content.fullScreenCover(
			isPresented: isPresented,
			onDismiss: onDismiss,
			content: popupBuilder
		)
	}
}
