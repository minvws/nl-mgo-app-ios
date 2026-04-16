/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Backing modifier for the `.confirmationAlert` view extension.
/// Wraps `ConfirmationAlertCoverView` in a full-screen cover so it renders as a custom
/// overlay rather than a system alert, enabling project-specific styling and animations.
private struct ConfirmationAlertModifier: ViewModifier {

	/// The bold title line shown at the top of the dialog card.
	let heading: String

	/// The explanatory text shown below the heading.
	let subheading: String

	/// Label for the primary confirm button.
	let actionText: String

	/// Label for the secondary cancel button.
	let cancelText: String

	/// Controls whether the dialog is visible. Set to `false` to dismiss, or `true` to present.
	@Binding var isPresented: Bool

	/// Called after the user taps the confirm button and the fade-out animation completes.
	let onConfirm: () -> Void

	func body(content: Content) -> some View {
		content
			.inspectableFullScreenCover(isPresented: $isPresented) {
				ConfirmationAlertCoverView(
					heading: heading,
					subheading: subheading,
					actionText: actionText,
					cancelText: cancelText,
					isPresented: $isPresented,
					onConfirm: onConfirm
				)
				.clearFullScreenCoverBackground()
				.interactiveDismissDisabled()
			}
	}
}

extension View {

	/// Presents a styled confirmation dialog as a full-screen cover overlay.
	///
	/// Use this instead of `.alert` when you need custom styling — the system alert cannot be
	/// restyled, whereas this modifier renders `ConfirmationAlertCoverView` with a dimmed
	/// backdrop and a Liquid Glass card (iOS 26+) or a themed card (iOS 15–25).
	///
	/// The cover fades in and out on its own. Interactive dismissal (swipe-to-dismiss) is
	/// disabled so the user must tap one of the two buttons.
	///
	/// - Parameters:
	///   - heading: Bold title shown at the top of the dialog card.
	///   - subheading: Explanatory text shown below the heading.
	///   - actionText: Label for the primary confirm button.
	///   - cancelText: Label for the secondary cancel button.
	///   - isPresented: Binding that controls visibility. Becomes `false` automatically after
	///     the user taps either button and the fade-out animation finishes.
	///   - onConfirm: Called after the user taps the confirm button and the cover is dismissed.
	///
	/// - Note: When setting `isPresented` to `true`, do so inside
	///   `withTransaction { $0.disablesAnimations = true }` to suppress the UIKit slide-in
	///   animation of the full-screen cover container.
	///
	/// ## Example
	/// ```swift
	/// .confirmationAlert(
	///     heading: String(localized: "delete.dialog.heading"),
	///     subheading: String(localized: "delete.dialog.subheading"),
	///     actionText: String(localized: "delete.dialog.confirm"),
	///     cancelText: String(localized: "common.cancel"),
	///     isPresented: $showDeleteAlert,
	///     onConfirm: { viewModel.reduce(.deleteItem) }
	/// )
	/// ```
	public func confirmationAlert(
		heading: String,
		subheading: String,
		actionText: String,
		cancelText: String,
		isPresented: Binding<Bool>,
		onConfirm: @escaping () -> Void
	) -> some View {
		modifier(ConfirmationAlertModifier(
			heading: heading,
			subheading: subheading,
			actionText: actionText,
			cancelText: cancelText,
			isPresented: isPresented,
			onConfirm: onConfirm
		))
	}
}
