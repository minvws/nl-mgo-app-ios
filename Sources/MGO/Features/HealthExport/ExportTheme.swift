/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// The color theme for the export
public class ExportTheme: ObservableObject {
	
	/// Create an export theme
	public init() { /* Public initializer needed for public access */ }
	
	// Text
	@Published public var primaryText: Color = Color.Export.primaryText
	@Published public var secondaryText: Color = Color.Export.secondaryText
	
	// Background
	@Published public var primaryBackground: Color = Color.Export.primaryBackground
	@Published public var secondaryBackground: Color = Color.Export.secondaryBackground
	
	// Border
	@Published public var border: Color = Color.Export.border
}

extension EnvironmentValues {
	
	/// Theme for the PDF Export
	@Entry var exportTheme: ExportTheme = ExportTheme()
}
