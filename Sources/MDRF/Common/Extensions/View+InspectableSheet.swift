/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzUI
import GifzFoundation

// See https://github.com/nalexn/ViewInspector/blob/0.9.11/guide_popups.md#sheet
extension View {
	
	/// Create an ispectable sheet
	/// - Parameters:
	///   - isPresented: A binding to a Boolean value that determines whether
	///     to present the sheet that you create in the modifier's
	///     `content` closure.
	///   - onDismiss: The closure to execute when dismissing the sheet.
	///   - content: A closure that returns the content of the sheet.
	/// - Returns: inspectable sheet
	func inspectableSheet<Sheet>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Sheet
	) -> some View where Sheet: View {
		
		return self.modifier(InspectableSheet(isPresented: isPresented, onDismiss: onDismiss, popupBuilder: content))
	}
}

struct InspectableSheet<Sheet>: ViewModifier where Sheet: View {
	
	/// A binding to a Boolean value that determines whether
	/// to present the sheet that you create in the modifier's
	let isPresented: Binding<Bool>

	/// The closure to execute when dismissing the sheet.
	let onDismiss: (() -> Void)?

	/// A closure that returns the content of the sheet.
	let popupBuilder: () -> Sheet
	
	func body(content: Self.Content) -> some View {
		content.sheet(isPresented: isPresented, onDismiss: onDismiss, content: popupBuilder)
	}
}
