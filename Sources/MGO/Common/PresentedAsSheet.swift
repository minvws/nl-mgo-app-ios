/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

// MARK: - Environment -

/// The environment key for the theme
public struct PresentedAsSheetEnvironmentKey: EnvironmentKey {
	public static let defaultValue: Bool = false
}

/// Placing the theme into the environment
public extension EnvironmentValues {
	var isPresentedAsSheet: Bool {
		get { self[PresentedAsSheetEnvironmentKey.self] }
		set { self[PresentedAsSheetEnvironmentKey.self] = newValue }
	}
}

extension View {
	public func isPresentedAsSheet(_ value: Bool) -> some View {
		environment(\.isPresentedAsSheet, value)
	}
}
