/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

// MARK: - Environment -

/// The environment key for the theme
public struct ThemeEnvironmentKey: EnvironmentKey {
	public static let defaultValue: any Themeable = Theme()
}

/// Placing the theme into the environment
public extension EnvironmentValues {
	var theme: any Themeable {
		get { self[ThemeEnvironmentKey.self] }
		set { self[ThemeEnvironmentKey.self] = newValue }
	}
}
