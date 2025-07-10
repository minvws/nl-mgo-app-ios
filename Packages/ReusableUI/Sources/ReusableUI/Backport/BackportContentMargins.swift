/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Back ported version of the content margins
/// - See: https://developer.apple.com/documentation/swiftui/view/contentmargins(_:for:)
public struct BackportContentMargins: ViewModifier {
	
	/// The edges to apply the margin to
	public var edges: Edge.Set
	
	/// The margin to appy
	public var margin: CGFloat
	
	/// Get the view for this modifier
	/// - Parameter content: content
	/// - Returns: view with view modifier
	public func body(content: Content) -> some View {
		
		if #available(iOS 17.0, *) {
			content
				.contentMargins(edges, margin)
		} else {
			content
		}
	}
}

extension View {
	
	/// Back ported version of the content margins
	/// - See: https://developer.apple.com/documentation/swiftui/view/contentmargins(_:for:)
	/// - Parameters:
	///   - margin: the margin to apply
	///   - edges: the edges to apply the margin to (defaults to .vertical)
	/// - Returns: View
	public func backportContentMargins(_ margin: CGFloat, edges: Edge.Set = .vertical) -> some View {
		modifier(BackportContentMargins(edges: edges, margin: margin))
	}
}
