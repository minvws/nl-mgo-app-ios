/*
 *  SPDX-FileCopyrightText: 2019 Alexey
 *  SPDX-License-Identifier: MIT
 */

import SwiftUI

// See https://github.com/nalexn/ViewInspector/blob/0.10.3/guide_popups.md#sheet
public extension View {
	
	/// Create an inspectable sheet
	/// - Parameters:
	///   - isPresented: A binding to a Boolean value that determines whether
	///     to present the sheet that you create in the modifier's `content` closure.
	///   - onDismiss: The closure to execute when dismissing the sheet.
	///   - content: A closure that returns the content of the sheet.
	/// - Returns: inspectable sheet
	func inspectableSheet<Sheet>(
		isPresented: Binding<Bool>,
		onDismiss: (() -> Void)? = nil,
		@ViewBuilder content: @escaping () -> Sheet
	) -> some View where Sheet: View {
		
		return self.modifier(
			InspectableSheet(
				isPresented: isPresented,
				onDismiss: onDismiss,
				popupBuilder: content
			)
		)
	}
}

public struct InspectableSheet<Sheet>: ViewModifier where Sheet: View {
	
	/// A binding to a Boolean value that determines whether
	/// to present the sheet that you create in the modifier's
	public let isPresented: Binding<Bool>

	/// The closure to execute when dismissing the sheet.
	public let onDismiss: (() -> Void)?

	/// A closure that returns the content of the sheet.
	public let popupBuilder: () -> Sheet
	
	/// Get the view for this modifier
	/// - Parameter content: Content
	/// - Returns: modified View
	public func body(content: Self.Content) -> some View {
		
		content.sheet(
			isPresented: isPresented,
			onDismiss: onDismiss,
			content: popupBuilder
		)
	}
}
