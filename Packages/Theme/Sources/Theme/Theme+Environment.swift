/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

// MARK: - Environment -

/// The enviroment key for the theme 
public struct ThemeEnvironmentKey: EnvironmentKey {
	public static let defaultValue: any Themeable = Theme()
}

/// Placing the theme into the enviroment
public extension EnvironmentValues {
	var theme: any Themeable {
		get { self[ThemeEnvironmentKey.self] }
		set { self[ThemeEnvironmentKey.self] = newValue }
	}
}
