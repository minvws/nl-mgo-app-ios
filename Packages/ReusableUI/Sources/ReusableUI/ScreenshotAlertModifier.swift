/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Show an alert when a screenshot is made
public struct ScreenshotAlertModifier: ViewModifier {
	
	/// the heading (title) for the alert
	var heading: LocalizedStringKey

	/// the subheading (message) for the alert
	var subheading: LocalizedStringKey
	
	/// the text for the action
	var actionText: LocalizedStringKey
	
	/// Should we show the alert after a screenshot was taken?
	@State private var showScreenshotAlert = false
	
	/// Get the view with an attached screenshot alert
	/// - Parameter content: the original content to attach the alert to
	/// - Returns: alert attached to the original content
	public func body(content: Content) -> some View {
		
		content
			.onReceive(
				// Listen to the `userDidTakeScreenshotNotification`
				NotificationCenter.default.publisher(
					for: UIApplication.userDidTakeScreenshotNotification
				), perform: { _ in
					// Trigger the alert
					showScreenshotAlert = true
				}
			)
			.alert(heading, isPresented: $showScreenshotAlert) {
				Button(actionText, role: .cancel) {
					showScreenshotAlert = false
				}
				.accessibilityIdentifier("screenshotalert.action")
			} message: {
				Text(subheading)
			}
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
		heading: LocalizedStringKey = "screenshotalert.heading",
		subheading: LocalizedStringKey = "screenshotalert.subheading",
		actionText: LocalizedStringKey = "screenshotalert.action") -> some View {
		modifier(
			ScreenshotAlertModifier(
				heading: heading,
				subheading: subheading,
				actionText: actionText
			)
		)
	}
}
