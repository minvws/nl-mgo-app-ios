/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOFoundation
import PdfExport

struct HealthDataMapper {

	/// The time zone used for all formatted dates in this mapper.
	private static let amsterdamTimeZone = TimeZone(identifier: "Europe/Amsterdam")

	/// The date formatter
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = amsterdamTimeZone
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	}()
	
	/// The time formatter
	private static let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = amsterdamTimeZone
		formatter.dateStyle = .none
		formatter.timeStyle = .short
		return formatter
	}()

	/// Returns the current date and time; defaults to `Date()` in production, injectable for tests.
	private let now: () -> Date

	init(now: @escaping () -> Date = { Date() }) {
		self.now = now
	}

	/// The formatted subheading string containing the current date and time
	private var subHeading: String {
		let date = now()
		return String(
			format: String(localized: "export_pdf.subheading"),
			arguments: [
				HealthDataMapper.dateFormatter.string(from: date),
				HealthDataMapper.timeFormatter.string(from: date)
			]
		)
	}

	/// Map a heading and its sub categories to pdf data
	/// - Parameters:
	///   - heading: the heading
	///   - blocks: the health sub categories
	/// - Returns: pdf Data
	func map(
		_ heading: String,
		blocks: [HealthCategoryBlock]
	) -> PdfData {

		return PdfData(
			heading: heading,
			subHeading: subHeading,
			tables: blocks.enumerated().map { index, block in
				mapBlock(block, isFirst: index == 0)
			},
			footer: String(localized: "export_pdf.footer")
		)
	}
	
	/// Map a single health UI Schema to pdf data
	/// - Parameters:
	///   - schema: the health UI Schema
	/// - Returns: pdf Data
	func map(_ schema: HealthUISchema) -> PdfData {

		return PdfData(
			heading: schema.label,
			subHeading: subHeading,
			tables: schema.children.compactMap(mapHealthUIGroup),
			footer: String(localized: "export_pdf.footer")
		)
	}
	
	// MARK: Helpers for a single UI Schema
	
	/// Maps a `HealthUIGroup` to a `PdfGroupedTables`, or returns `nil` if the group is excluded from print.
	/// - Parameter group: the UI group to transform
	/// - Returns: a PDF grouped tables, or `nil` if `excludeFromPrint` is set
	private func mapHealthUIGroup(group: HealthUIGroup) -> PdfGroupedTables? {
		
		guard group.excludeFromPrint != true else { return nil }
		
		return PdfGroupedTables(
			heading: group.label,
			tables: [mapUIElements(elements: group.uiElements)],
			shouldStartOnNewPage: false
		)
	}

	/// Wraps a list of UI elements into a single `PdfTable`.
	/// - Parameter elements: the UI elements to transform
	/// - Returns: a `PdfTable` with a sub table per element
	private func mapUIElements(elements: [UIElementProtocol]) -> PdfTable {

		return PdfTable(
			heading: nil,
			subTables: elements.map(mapUIElement)
		)
	}
	
	/// Maps a single UI element to a `PdfSubTable` using its PDF mapping.
	/// - Parameter element: the UI element to transform
	/// - Returns: a `PdfSubTable` containing the element's key-value pair, or empty data if no mapping is defined
	private func mapUIElement(element: UIElementProtocol) -> PdfSubTable {
		
		return PdfSubTable(
			heading: nil,
			data: element.getPdfMapping().map { [$0] } ?? []
		)
	}
	
	// MARK: Helpers for mapping blocks
	
	/// Transform a Health sub category in a PDF Grouped tables
	/// - Parameter subCategory: the sub category to transform
	/// - Returns: a PDF grouped table
	private func mapBlock(
		_ block: HealthCategoryBlock,
		isFirst: Bool
	) -> PdfGroupedTables {
		
		return PdfGroupedTables(
			heading: String(
				localized: String.LocalizationValue(
					// block.heading is a server-provided localisation key;
					// look it up in the bundle's strings table, falling back to the raw key.
					stringLiteral: block.heading
				)
			),
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
			},
			shouldStartOnNewPage: !isFirst
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
