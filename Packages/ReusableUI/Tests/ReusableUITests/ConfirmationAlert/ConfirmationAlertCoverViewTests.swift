/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import OSVersion
import MGOTest
import Testing
import SwiftUI

/// Tests for ``ConfirmationAlertCoverView``.
@MainActor
final class ConfirmationAlertCoverViewTests {

	/// Stub texts used across all tests; content is intentionally generic since these tests cover behaviour, not localisation.
	private let heading = "Heading"
	private let subheading = "subheading"
	private let actionText = "OK Action"
	private let cancelText = "Cancel Action"

	// MARK: - Snapshot Tests

	/// Verifies the default (iOS 26+) card appearance with Liquid Glass styling.
	@Test("Snapshot: confirmation dialog with Liquid Glass (iOS 26+)")
	func snapshot_confirmationDialog() {

		// When — startVisible: true skips the fade-in so the view is fully opaque from the
		// first frame, giving a deterministic snapshot regardless of RunLoop timing.
		// A white background makes the semi-transparent overlay clearly visible.
		let content = ZStack {
			Color.white.ignoresSafeArea()
			ConfirmationAlertCoverView(
				heading: heading,
				subheading: subheading,
				actionText: actionText,
				cancelText: cancelText,
				isPresented: .constant(true),
				onConfirm: { /* no-op */ },
				startVisible: true
			)
		}

		takeSnapShots(content: content)
	}

	/// Verifies the fallback card appearance on iOS 18 (theme tertiary background, no Liquid Glass).
	@Test("Snapshot: confirmation dialog with tertiary background (iOS 18)")
	func snapshot_confirmationDialog_iOS18() {

		// When — startVisible: true skips the fade-in so the view is fully opaque from the
		// first frame, giving a deterministic snapshot regardless of RunLoop timing.
		// A white background makes the semi-transparent overlay clearly visible.
		let content = ZStack {
			Color.white.ignoresSafeArea()
			ConfirmationAlertCoverView(
				heading: heading,
				subheading: subheading,
				actionText: actionText,
				cancelText: cancelText,
				isPresented: .constant(true),
				onConfirm: { /* no-op */ },
				startVisible: true,
				osVersionChecker: OSVersionCheckerFalse()
			)
		}

		takeSnapShots(content: content)
	}

	// MARK: - Interaction Tests

	/// Tapping the confirm button should invoke `onConfirm` after the dismiss animation completes.
	@Test("Tapping the confirm button calls onConfirm")
	func yesButton_shouldCallOnConfirm() async throws {

		try await confirmation("onConfirm called") { confirm in

			// Given
			let sut = ConfirmationAlertCoverView(
				heading: heading,
				subheading: subheading,
				actionText: actionText,
				cancelText: cancelText,
				isPresented: .constant(true),
				onConfirm: { confirm() }
			)

			// When
			let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "confirmationAlertCoverView.action")
			try view.view(CallToActionButton.self).find(button: actionText).tap()

			// Then — wait for the 250ms dismiss animation before onConfirm is invoked
			try await Task.sleep(nanoseconds: 350_000_000)
		}
	}

	/// Tapping the cancel button should set `isPresented` to `false` after the dismiss animation completes.
	@Test("Tapping the cancel button dismisses the cover")
	func cancelButton_shouldDismiss() async throws {

		try await confirmation("isPresented set to false") { confirm in

			// Given
			let sut = ConfirmationAlertCoverView(
				heading: heading,
				subheading: subheading,
				actionText: actionText,
				cancelText: cancelText,
				isPresented: Binding(
					get: { true },
					set: { newValue in
						if !newValue { confirm() }
					}
				),
				onConfirm: { /* no-op */ }
			)

			// When
			let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "confirmationAlertCoverView.cancel")
			try view.view(CallToActionButton.self).find(button: cancelText).tap()

			// Then — wait for the 250ms dismiss animation before isPresented is set to false
			try await Task.sleep(nanoseconds: 350_000_000)
		}
	}
}
