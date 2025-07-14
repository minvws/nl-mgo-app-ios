/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOFoundation
import PdfExport

class HealthDataMapper {
	
	/// The date formatter
	@MainActor private static var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(abbreviation: "CET")
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	}()
	
	/// The time formatter
	@MainActor private static var timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(abbreviation: "CET")
		formatter.dateStyle = .none
		formatter.timeStyle = .short
		return formatter
	}()
	
	/// Map a category and its sub categories to pdf data
	/// - Parameters:
	///   - category: the health category
	///   - data: the health sub categories
	/// - Returns: pdf Data
	@MainActor func map(_ category: HealthCategories.Category, data: [HealthSubCategory]) -> PdfData? {
		
		let date = Current.now()
		
		return PdfData(
			heading: String(localized: String.LocalizationValue(stringLiteral: category.heading.stringKey)),
			subHeading: String(
				format: String(localized: "export_pdf.subheading"),
				arguments: [
					HealthDataMapper.dateFormatter.string(from: date),
					HealthDataMapper.timeFormatter.string(from: date)
				]
			),
			tables: data.map(mapSubCategory),
			footer: String(localized: "export_pdf.footer")
		)
	}
	
	/// Transform a Health sub category in a PDF Grouped tables
	/// - Parameter subCategory: the sub category to transform
	/// - Returns: a PDF grouped table
	@MainActor private func mapSubCategory(_ subCategory: HealthSubCategory) -> PdfGroupedTables {
		
		return PdfGroupedTables(
			heading: subCategory.heading,
			tables: subCategory.rows.compactMap { row in
				let subTables = mapSchema(row.schema)
				if subTables.isEmpty {
					return nil
				} else {
					return PdfTable(heading: row.heading, subTables: subTables)
				}
			}
		)
	}
	
	/// Transform a Health ui schema into an array of PDF sub tables
	/// - Parameter schema: the health schema to transform
	/// - Returns: an array of PDF sub tables
	@MainActor private func mapSchema(_ schema: HealthUISchema) -> [PdfSubTable] {
		
		var result = [PdfSubTable]()
		
		for child in schema.children {
			let pairs = child.uiElements.compactMap(mapElement)
			if pairs.isNotEmpty {
				result.append(PdfSubTable(heading: child.label, data: pairs))
			}
		}
		return result
	}
	
	/// Map a UIElement onto a PDF sub table pair
	/// - Parameter element: the element
	/// - Returns: PDF sub table pair
	@MainActor private func mapElement(_ element: UIElementProtocol) -> PdfSubTablePair? {
		
		if element is SingleValue,
		   let value = (element as? SingleValue)?.display {
			return PdfSubTablePair(key: element.label, value: value)
		}
		if element is MultipleValues,
		   let value = (element as? MultipleValues)?.display?.joined(separator: ", ") {
			return PdfSubTablePair(key: element.label, value: value)
		}
		if element is MultipleGroupedValues,
		   let display = (element as? MultipleGroupedValues)?.display {
			let value = display.map { $0.joined(separator: ", ") }.joined(separator: ", ")
			return PdfSubTablePair(key: element.label, value: value)
		}
		if element is ReferenceValue,
		   let value = (element as? ReferenceValue)?.display {
			return PdfSubTablePair(key: element.label, value: value)
		}
		return nil
	}
}
