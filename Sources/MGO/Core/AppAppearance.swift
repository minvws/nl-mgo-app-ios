/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	public var key: LocalizedStringKey {
		switch self {
			case .light:
				return "settings.display.light"
			case .dark:
				return "settings.display.dark"
			case .system:
				return "settings.display.system.heading"
		}
	}
}
