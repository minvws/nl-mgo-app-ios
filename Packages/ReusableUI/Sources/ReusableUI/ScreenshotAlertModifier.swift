/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Show an alert when a screenshot is made
public struct ScreenshotAlertModifier: ViewModifier {

	/// the heading (title) for the alert
	var heading: String

	/// the subheading (message) for the alert
	var subheading: String

	/// the text for the action
	var actionText: String

	/// whether to render the debug screenshot trigger button
	var showDebugTrigger: Bool

	/// Get the view with an attached screenshot alert
	/// - Parameter content: the original content to attach the alert to
	/// - Returns: view with screenshot listener
	public func body(content: Content) -> some View {

		content
			.onReceive(
				NotificationCenter.default.publisher(
					for: UIApplication.userDidTakeScreenshotNotification
				), perform: { _ in
					presentAlert()
				}
			)
			.screenshotTrigger(enabled: showDebugTrigger)
	}

	/// Present a UIAlertController on the topmost view controller so it never
	/// dismisses an already-presented sheet.
	func presentAlert(from root: UIViewController? = nil) {

		guard let root = root ?? UIApplication.shared.connectedScenes
			.compactMap({ $0 as? UIWindowScene })
			.flatMap({ $0.windows })
			.first(where: { $0.isKeyWindow })?
			.rootViewController else { return }

		let alert = UIAlertController(
			title: heading,
			message: subheading,
			preferredStyle: .alert
		)
		let action = UIAlertAction(title: actionText, style: .cancel)
		action.accessibilityIdentifier = "screenshotalert.action"
		alert.addAction(action)
		root.topMost.present(alert, animated: true)
	}
}

private extension UIViewController {

	/// Walk the presentedViewController chain to find the topmost presented controller.
	var topMost: UIViewController {
		presentedViewController?.topMost ?? self
	}
}

extension View {

	/// Show an alert when a screenshot was taken
	/// - Parameters:
	///   - heading: the heading (title) for the alert
	///   - subheading: the subheading (message) for the alert
	///   - actionText: the text for the action
	/// - Returns: View with screenshot listener
	public func screenshotAlert(
		heading: String = NSLocalizedString("screenshotalert.heading", comment: ""),
		subheading: String = NSLocalizedString("screenshotalert.subheading", comment: ""),
		actionText: String = NSLocalizedString("screenshotalert.action", comment: "")
	) -> some View {

		modifier(
			ScreenshotAlertModifier(
				heading: heading,
				subheading: subheading,
				actionText: actionText,
				showDebugTrigger: CommandLine.arguments.contains("-simulateScreenshot")
			)
		)
	}

	/// Overlay a hidden trigger button that posts the screenshot notification.
	/// Only rendered when `enabled` is true (i.e. under the `-simulateScreenshot` launch argument).
	public func screenshotTrigger(enabled: Bool = CommandLine.arguments.contains("-simulateScreenshot")) -> some View {

		overlay(alignment: .center) {
			if enabled {
				Button {
					NotificationCenter.default.post(
						name: UIApplication.userDidTakeScreenshotNotification,
						object: nil
					)
				} label: {
					Text("Screenshot")
						.foregroundStyle(.clear)
						.frame(width: 100, height: 20)
				}
				.accessibilityIdentifier("debug.screenshot.trigger")
			}
		}
	}
}
