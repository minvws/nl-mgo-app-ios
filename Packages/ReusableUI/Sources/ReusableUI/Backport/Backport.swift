/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

// See https://davedelong.com/blog/2021/10/09/simplifying-backwards-compatibility-in-swift/
public struct Backport<Content> {
	public let content: Content
	
	/// Create a backport object
	/// - Parameter content: the content
	public init(_ content: Content) {
		self.content = content
	}
}

public extension View {
	// A name space for back ported methods
	var backport: Backport<Self> { Backport(self) }
}
