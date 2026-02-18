/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

extension View {
	
	public func resignKeyboardOnDragGesture() -> some View {
		return modifier(ResignKeyboardOnDragGesture())
	}
}

public struct ResignKeyboardOnDragGesture: ViewModifier {
	
	var dragGesture = DragGesture().onChanged { _ in
		UIApplication.shared.endEditing()
	}
	
	var tapGesture = TapGesture().onEnded {
		UIApplication.shared.endEditing()
	}
	
	public func body(content: Content) -> some View {
		content
			.simultaneousGesture(dragGesture)
			.simultaneousGesture(tapGesture)
	}
}
