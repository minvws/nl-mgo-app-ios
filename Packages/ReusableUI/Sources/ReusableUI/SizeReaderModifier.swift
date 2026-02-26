/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// See  https://stackoverflow.com/a/69781817/443270
public struct SizeReaderModifier: ViewModifier {
	@Binding var size: CGSize
	
	@ViewBuilder
	public func body(content: Content) -> some View {
		if #available(iOS 16.0, *), !ProcessInfo.processInfo.arguments
			.contains("--unittesting") {
			content
				.backport.onGeometryChange(for: CGSize.self) { geometry in
					geometry.size
				} action: { newValue in
					size = newValue
				}
		} else {
			content
				.background(
					GeometryReader { geometry in
						Color.clear.onAppear {
							size = geometry.size
						}
						.onChange(of: geometry.size) { newSize in
							size = newSize
						}
					}
				)
		}
	}
}

extension View {
	public func readSize(_ size: Binding<CGSize>) -> some View {
		self.modifier(SizeReaderModifier(size: size))
	}
}
