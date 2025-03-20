/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// The appearance of the app
public enum AppAppearance: String, Identifiable {
	
	/// Dark Mode
	case dark
	
	/// Light Mode
	case light
	
	/// Use the system value
	case system
	
	/// Identifier
	public var id: String { self.rawValue }
	
	/// The associated color scheme
	public var colorScheme: ColorScheme? {
		switch self {
			case .light:
				return .light
			case .dark:
				return .dark
			case .system:
				return nil
		}
	}
}
