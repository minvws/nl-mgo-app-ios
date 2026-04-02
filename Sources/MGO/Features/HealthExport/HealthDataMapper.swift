/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOFoundation
import PdfExport

@MainActor
struct HealthDataMapper {
	
	/// The date formatter
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(identifier: "Europe/Amsterdam")
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	}()
	
	/// The time formatter
	private static let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(identifier: "Europe/Amsterdam")
		formatter.dateStyle = .none
		formatter.timeStyle = .short
		return formatter
	}()
	
	/// Map a heading and its sub categories to pdf data
	/// - Parameters:
	///   - heading: the heading
	///   - blocks: the health sub categories
	/// - Returns: pdf Data
	func map(
		_ heading: String,
		blocks: [HealthCategoryBlock]
	) -> PdfData? {
		
		let date = Container.shared.now()()
		
		return PdfData(
			heading: heading,
			subHeading: String(
				format: String(localized: "export_pdf.subheading"),
				arguments: [
					HealthDataMapper.dateFormatter.string(from: date),
					HealthDataMapper.timeFormatter.string(from: date)
				]
			),
			tables: blocks.map(mapBlock),
			footer: String(localized: "export_pdf.footer")
		)
	}
	
	/// Transform a Health sub category in a PDF Grouped tables
	/// - Parameter subCategory: the sub category to transform
	/// - Returns: a PDF grouped table
	private func mapBlock(
		_ block: HealthCategoryBlock
	) -> PdfGroupedTables {
		
		return PdfGroupedTables(
			heading: String(localized: String.LocalizationValue(stringLiteral: block.heading)),
			tables: block.rows.compactMap { row in
				let subTables = mapSchema(row.schema)
				if subTables.isEmpty {
					return nil
				} else {
					return PdfTable(
						heading: row.heading,
						subTables: subTables
					)
				}
			}
		)
	}
	
	/// Transform a Health ui schema into an array of PDF sub tables
	/// - Parameter schema: the health schema to transform
	/// - Returns: an array of PDF sub tables
	private func mapSchema(
		_ schema: HealthUISchema
	) -> [PdfSubTable] {
		schema.children.compactMap { child in
			// Only include where excludeFromPrint is false
			guard child.excludeFromPrint != true else { return nil }
			
			let pairs = child.uiElements.compactMap { $0.getPdfMapping() }
			return pairs.isEmpty ? nil : PdfSubTable(
				heading: child.label,
				data: pairs
			)
		}
	}
}
