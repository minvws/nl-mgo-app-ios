/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct BackportContentMargins: ViewModifier {
	
	/// The edges to apply the margin to
	var edges: Edge.Set
	
	/// The margin to appy
	var margin: CGFloat
	
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
	/// - Parameters:
	///   - margin: the margin to apply
	///   - edges: the edges to apply the margin to (defaults to .vertical)
	/// - Returns: View
	public func backportContentMargins(_ margin: CGFloat, edges: Edge.Set = .vertical) -> some View {
		modifier(BackportContentMargins(edges: edges, margin: margin))
	}
}
