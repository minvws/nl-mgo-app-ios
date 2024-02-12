/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// See  https://stackoverflow.com/a/69781817/443270
public struct SizeReaderModifier: ViewModifier {
	@Binding var size: CGSize
	
	public func body(content: Content) -> some View {
		content.background(
			GeometryReader { geometry in
				Color.clear.onAppear {
					size = geometry.size
				}
			}
		)
	}
}

extension View {
	public func readSize(_ size: Binding<CGSize>) -> some View {
		self.modifier(SizeReaderModifier(size: size))
	}
}
