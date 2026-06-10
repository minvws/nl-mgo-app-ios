/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import OSVersion
import Theme
import ReusableUI

public struct RestrictedBrowserView: View {

	/// Initializer
	/// - Parameters:
	///   - viewModel: the view model
	///   - osVersionChecker: version checker used to gate iOS 26 styling
	public init(viewModel: RestrictedBrowserViewModel, osVersionChecker: any OSVersionProtocol = OSVersionChecker()) {
		self._viewModel = StateObject(wrappedValue: viewModel)
		self.osVersionChecker = osVersionChecker
	}

	/// The Theme
	@Environment(\.mgoTheme) var theme

	/// The View Model
	@StateObject var viewModel: RestrictedBrowserViewModel

	var osVersionChecker: any OSVersionProtocol

	public var body: some View {

		VStack(spacing: 0) {

			Divider()
				.overlay(theme.separators.secondary)

			WebView(viewModel: viewModel, url: viewModel.url)
				.background(theme.backgrounds.primary)
				.backport.toolbarBackground(
					theme.backgrounds.secondary,
					for: .navigationBar
				)
				.toolbar(
					content: {
						ToolbarItemGroup(
							placement: .topBarTrailing,
							content: {
								if !osVersionChecker.available(version: .iOS(.v26)) {
									Spacer()
								}
								Button {
									viewModel.reduce(.safariButtonPressed)
								} label: {
									Image(systemName: "safari")
								}
								.buttonStyle(NavigationBarButtonStyle(osVersionChecker: osVersionChecker))
								.accessibilityIdentifier("safariButton")
								.accessibilityLabel("Open in browser")
							}
						)
					}
				)
				.accessibilityIdentifier("restrictedBrowserView")
		}
	}
}

struct NavigationBarButtonStyle: ButtonStyle {

	/// The Theme
	@Environment(\.mgoTheme) var theme

	var osVersionChecker: any OSVersionProtocol

	init(osVersionChecker: any OSVersionProtocol = OSVersionChecker()) {
		self.osVersionChecker = osVersionChecker
	}

	/// Style the button to a navigation bar button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {

		if osVersionChecker.available(version: .iOS(.v26)) {
			configuration.label
				.foregroundStyle(theme.labels.primary)
		} else {
			configuration.label
				.foregroundStyle(configuration.isPressed ? theme.actions.ghost.hover : theme.actions.ghost.text)
		}
	}
}
