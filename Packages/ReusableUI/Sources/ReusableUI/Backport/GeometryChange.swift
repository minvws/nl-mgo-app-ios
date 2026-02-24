/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {
	
	@ViewBuilder func onGeometryChange<T>(
		for type: T.Type,
		of transform: @escaping @Sendable (GeometryProxy) -> T,
		action: @escaping (_ newValue: T) -> Void) -> some View where T: Equatable, T: Sendable {
		
		if #available(iOS 16.0, *) {
			content.onGeometryChange(for: type, of: transform, action: action)
		} else {
			content
		}
	}
}
