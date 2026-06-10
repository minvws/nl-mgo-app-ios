/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import UIKit
import Testing
import ViewControllerPresentationSpy
import MGOTest

struct ScreenshotAlertModifierTests {

	@Test @MainActor func presentAlert_presentsAlertWithCorrectContent() {

		// Given
		let alertVerifier = AlertVerifier()
		let sut = ScreenshotAlertModifier(
			heading: "Heading",
			subheading: "Subheading",
			actionText: "OK",
			showDebugTrigger: false
		)

		// When
		sut.presentAlert(from: UIViewController())

		// Then
		alertVerifier.verify(
			title: "Heading",
			message: "Subheading",
			animated: true,
			actions: [
				.cancel("OK")
			]
		)
	}

	@Test @MainActor func presentAlert_withDebugTriggerEnabled_presentsAlertWithCorrectContent() {

		// Given
		let alertVerifier = AlertVerifier()
		let sut = ScreenshotAlertModifier(
			heading: "Heading",
			subheading: "Subheading",
			actionText: "OK",
			showDebugTrigger: true
		)

		// When
		sut.presentAlert(from: UIViewController())

		// Then
		alertVerifier.verify(
			title: "Heading",
			message: "Subheading",
			animated: true,
			actions: [
				.cancel("OK")
			]
		)
	}

	@Test @MainActor func screenshotTrigger_enabled_buttonPostsNotification() throws {

		// Given
		struct TestView: View {
			var body: some View {
				Text("Test").screenshotTrigger(enabled: true)
			}
		}
		var notificationPosted = false
		let token = NotificationCenter.default.addObserver(
			forName: UIApplication.userDidTakeScreenshotNotification,
			object: nil,
			queue: .main
		) { _ in MainActor.assumeIsolated { notificationPosted = true } }
		defer { NotificationCenter.default.removeObserver(token) }

		// When
		try TestView()
			.inspect()
			.find(viewWithAccessibilityIdentifier: "debug.screenshot.trigger")
			.button()
			.tap()

		// Then
		#expect(notificationPosted)
	}

	@Test @MainActor func presentAlert_withNoRootVC_doesNotPresent() {

		// Given
		let alertVerifier = AlertVerifier()
		let sut = ScreenshotAlertModifier(
			heading: "Heading",
			subheading: "Subheading",
			actionText: "OK",
			showDebugTrigger: false
		)

		// When — nil triggers the guard early-exit
		sut.presentAlert(from: nil)

		// Then
		#expect(alertVerifier.presentedCount == 0)
	}
}
