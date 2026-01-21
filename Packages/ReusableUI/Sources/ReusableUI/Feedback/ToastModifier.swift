/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct ToastModifier: ViewModifier {
	
	/// The feedback to display
	var feedback: Feedback?
	
	/// Should we use iOS 26 style rounded corners
	var rounded: Bool
	
	/// The action when the user dismisses the toast
	var closeAction: (() -> Void)?
	
	public func body(content: Content) -> some View {
		if let feedback {
			content
				.overlay(alignment: .bottom) {
					ToastView(feedback, rounded: rounded) {
						withAnimation {
							closeAction?()
							Haptic.light()
						}
					}
					.padding(16)
				}
		} else {
			content
		}
	}
}

extension View {
	
	/// Add a toast to this view
	/// - Parameters:
	///   - feedback: the feedback to show
	///   - rounded: Should we use iOS 26 style rounded corners
	///   - closeAction: action when the user dismisses the toast
	/// - Returns: modified view with toast
	public func toast(_ feedback: Feedback?, rounded: Bool, closeAction: (() -> Void)?) -> some View {
		modifier(ToastModifier(feedback: feedback, rounded: rounded, closeAction: closeAction))
	}
}

#Preview {
	Text(verbatim: "test")
		.toast(
			Feedback(title: "Heading", subtitle: "action", type: .success),
			rounded: true,
			closeAction: nil
		)
}
