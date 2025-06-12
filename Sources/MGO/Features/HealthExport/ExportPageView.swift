/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct ExportPageView: View {
	
	/// The Theme
	@Environment(\.exportTheme) var exportTheme
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			
			HStack {
				Text("Rool Medicijnen")
					.font(Font.custom("Helvetica", size: 24).weight(.bold))
					.foregroundStyle(exportTheme.primaryText)
				Spacer()
				Text("Opgeslagen op 1 januari 2026 om 14:45 uur")
					.font(Font.custom("Helvetica", size: 10))
					.foregroundStyle(exportTheme.secondaryText)
			}
			
			Text("Wat je nu gebruikt")
				.font(Font.custom("Helvetica", size: 16).weight(.bold))
				.foregroundStyle(exportTheme.primaryText)
			
			VStack(alignment: .leading, spacing: 0) {
				
				tableRowHeading(heading: "Zestril tablet 10 mg")
				tableRow(heading: "Gebruiksaanwijzing", value: "1 maal per dat 1 tablet, oraal")
				tableRow(heading: "Hoeveelheid per keer", value: "1 stuk")
				
				tableRowSubHeading(heading: "Periode van gebruik")
				tableRow(heading: "Ingangsdatum", value: "20 juni 2018", bottomBorder: true)
				
			}
			.font(Font.custom("Helvetica", size: 10))
			.foregroundStyle(exportTheme.primaryText)
			
			Spacer()
			
			HStack {
				Text("export_pdf.footer")
				Spacer()
				Text("Pagina 1 van 1")
			}
			.font(Font.custom("Helvetica", size: 10))
			.foregroundStyle(exportTheme.secondaryText)
		}
		.background(exportTheme.primaryBackground)
		
		.padding(.horizontal, 28)
		.padding(.vertical, 28)
	}

	@ViewBuilder func tableRowHeading(heading: String) -> some View {
		
		HStack {
			Spacer()
			
			Text(heading)
				.font(Font.custom("Helvetica", size: 12).weight(.bold))
				.padding(6)
			
			Spacer()
		}
		.overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(exportTheme.border), alignment: .top)
		.overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(exportTheme.border), alignment: .leading)
		.overlay(Rectangle().frame(width: 1, height: nil, alignment: .trailing).foregroundColor(exportTheme.border), alignment: .trailing)
	}
	
	@ViewBuilder func tableRowSubHeading(heading: String) -> some View {
		
		HStack {
			Text(heading)
			Spacer()
		}
		.padding(6)
		.overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(exportTheme.border), alignment: .top)
		.overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(exportTheme.border), alignment: .leading)
		.overlay(Rectangle().frame(width: 1, height: nil, alignment: .trailing).foregroundColor(exportTheme.border), alignment: .trailing)
		
	}
	
	/// A table row
	/// - Parameters:
	///   - heading: the heading
	///   - value: the value
	/// - Returns: View
	@ViewBuilder func tableRow(heading: String, value: String, bottomBorder: Bool = false) -> some View {
		
		HStack {
			Text(heading)
				.padding(6)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(exportTheme.secondaryBackground)
				.overlay(Rectangle().frame(width: 1, height: nil, alignment: .trailing).foregroundColor(exportTheme.border), alignment: .trailing)
			Text(value)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(6)
		}
		.overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(exportTheme.border), alignment: .top)
		.overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(exportTheme.border), alignment: .leading)
		.overlay(Rectangle().frame(width: 1, height: nil, alignment: .trailing).foregroundColor(exportTheme.border), alignment: .trailing)
		
		.when(bottomBorder) { view in
		
			view
				.overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(exportTheme.border), alignment: .bottom)
		}
	}
}

#Preview {
	ExportPageView()
}
