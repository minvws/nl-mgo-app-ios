/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Make a view look good on an iPad
public struct IPadLayoutViewModifier: ViewModifier {
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Gutter {
			static let leading: Double = 0.125
			static let trailing: Double = 0.125
		}
	}
	
	/// Should we adjust the layout for iPad (i.e., are we running on an iPad)?
	private var shouldLayoutForiPad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The horizontal size classes (to determine the layout)
	@Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

	/// should we force the iPad Layout?
	public var force: Bool
	
	/// Initializer
	/// - Parameter force: should we force the iPad Layout?
	public init(force: Bool = false) {
		self.force = force
	}
	
	public func body(content: Content) -> some View {
		
		content
			.when((shouldLayoutForiPad && horizontalSizeClass == .regular) || force, transform: { view in
				GeometryReader(content: {geometry in
					HStack(spacing: 0, content: {
						Spacer(minLength: geometry.size.width * ViewTraits.Gutter.leading)
						view
						Spacer(minLength: geometry.size.width * ViewTraits.Gutter.trailing)
					})
					.background(theme.backgroundPrimary.ignoresSafeArea())
				})
			})
	}
}

extension View {
	
	/// Layout the view for an iPad
	/// - Returns: view optimized for iPad when viewed on an iPad
	/// - Parameter force: Do not depend on the actual device, force the layout in iPad mode
	public func layoutForIPad(force: Bool = false) -> some View {
		modifier(IPadLayoutViewModifier(force: force))
	}
}
