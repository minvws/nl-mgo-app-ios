/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct ToastModifier: ViewModifier {
	
	/// The feedback to display
	var feedback: Feedback?
	
	/// The action when the user dismisses the toast
	var closeAction: (() -> Void)?
	
	public func body(content: Content) -> some View {
		if let feedback {
			content
				.overlay(alignment: .bottom) {
					ToastView(feedback) {
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
	///   - closeAction: action when the user dismisses the toast
	/// - Returns: modified view with toast
	public func toast(_ feedback: Feedback?, closeAction: (() -> Void)?) -> some View {
		modifier(ToastModifier(feedback: feedback, closeAction: closeAction))
	}
}

#Preview {
	Text(verbatim: "test")
		.toast(
			Feedback(title: "Heading", subtitle: "action", type: .success),
			closeAction: nil
		)
}
