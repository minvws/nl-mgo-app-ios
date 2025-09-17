/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct TrailingIconLabelStyle: LabelStyle {
	
	public init() { /* pulbic initializer */ }
	
	public func makeBody(configuration: Configuration) -> some View {
		HStack {
			configuration.title
			configuration.icon
		}
	}
}
