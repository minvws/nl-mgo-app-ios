/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import Theme
import ReusableUI

public struct RestrictedBrowserView: View {
	
	/// Initializer
	/// - Parameter viewModel: the view model
	public init(viewModel: RestrictedBrowserViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The View Model
	@StateObject var viewModel: RestrictedBrowserViewModel
	
	public var body: some View {
		
		VStack(spacing: 0) {
			
			Divider()
				.overlay(theme.separators.secondary)
			
			WebView(viewModel: viewModel, url: viewModel.url)
				.background(theme.backgrounds.primary)
				.backport.toolbarBackground(theme.backgrounds.secondary, for: .navigationBar)
				.toolbar(
					content: {
						ToolbarItemGroup(
							placement: .topBarTrailing,
							content: {
								Spacer()
								
								Button {
									viewModel.reduce(.safariButtonPressed)
								} label: {
									Image(systemName: "safari")
								}
								.buttonStyle(NavigationBarButtonStyle())
								.accessibilityIdentifier("safariButton")
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
	@Environment(\.theme) var theme
	
	/// Style the button to a navigation bar button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.foregroundStyle(configuration.isPressed ? theme.actions.tertiary.hover : theme.actions.tertiary.text)
	}
}
