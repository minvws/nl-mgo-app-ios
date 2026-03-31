/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// The color theme for the export
public class ExportTheme {
	
	/// Create an export theme
	public init() { /* Public initializer needed for public access */ }
	
	// Text
	@Published public var primaryText: Color = Color("PrimaryText", bundle: .module)
	@Published public var secondaryText: Color = Color("SecondaryText", bundle: .module)
	
	// Border
	@Published public var border: Color = Color("Border", bundle: .module)
}

/// The color theme for the view
public class ViewTheme {
	
	/// Create an view theme
	public init() { /* Public initializer needed for public access */ }
	
	// Background
	@Published public var primaryBackground: Color = Color("Background", bundle: .module)
}
