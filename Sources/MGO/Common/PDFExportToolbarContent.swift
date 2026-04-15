/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// Toolbar content showing the PDF export button, shared across health views
struct PDFExportToolbarContent: ToolbarContent {

	/// The Theme
	@Environment(\.mgoTheme) var theme

	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// The action when tapped
	var action: () -> Void
	
	/// The view
	var body: some ToolbarContent {
		
		ToolbarItemGroup(
			placement: .topBarTrailing,
			content: {

				if osVersionChecker.available(version: .iOS(.v26)) {
					if #available(iOS 26.0, *) {
						Button(
							action: action,
							label: {
								Label("export_pdf.menu", systemImage: "square.and.arrow.down")
									.labelStyle(IconOnlyLabelStyle())
									.foregroundStyle(theme.labels.primary)
							}
						)
						.tint(theme.labels.primary)
						.glassEffect(in: .circle)
						.accessibilityLabel("export_pdf.menu.save_pdf")
						.accessibilityIdentifier("export_pdf.menu")
					}
				} else {
					Button(action: action) {
						Image(ImageResource.Icon.download)
					}
					.tint(theme.labels.primary)
					.accessibilityLabel("export_pdf.menu")
					.accessibilityIdentifier("export_pdf.menu")
				}
			}
		)
	}
}
