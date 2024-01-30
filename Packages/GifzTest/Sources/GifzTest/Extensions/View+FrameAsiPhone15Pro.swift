/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct FrameAsiPhone15ProModifier: ViewModifier {
	
	/// Frame as iPhone 25 Pro
	/// - Parameter content: the content
	/// - Returns: the content with a frame of `393 * 852` just like an iPhone 15 Pro
	public func body(content: Content) -> some View {
		content
			.frame(width: 393, height: 852)
	}
}

extension View {
	
	/// Frame as iPhone 25 Pro
	/// - Returns: the content with a frame of `393 * 852` just like an iPhone 15 Pro
	public func frameAsiPhone15Pro() -> some View {
		modifier(FrameAsiPhone15ProModifier())
	}
}
