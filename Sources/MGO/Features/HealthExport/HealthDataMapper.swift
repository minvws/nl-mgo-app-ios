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
	@MainActor func map(_ category: SharedHealthCategories.Category, data: [HealthCategoryBlock]) -> PdfData? {
		
		let date = Container.shared.now()()
		
		return PdfData(
			heading: String(localized: String.LocalizationValue(stringLiteral: category.heading)),
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
	@MainActor private func mapSubCategory(_ subCategory: HealthCategoryBlock) -> PdfGroupedTables {
		
		return PdfGroupedTables(
			heading: String(localized: String.LocalizationValue(stringLiteral: subCategory.heading)),
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
		   let display = (element as? SingleValue)?.display,
		   let value = mapElement(display) {
			return PdfSubTablePair(key: element.label, value: value)
		}
		
		if element is MultipleValues,
		   let display = (element as? MultipleValues)?.display {
			let values = display
				.compactMap { mapElement($0) }
			
			return PdfSubTablePair(
				key: element.label,
				value: values.joined(separator: ", ")
			)
		}
		
		if element is MultipleGroupedValues,
		   let display = (element as? MultipleGroupedValues)?.display {
			let values = display
				.flatMap { $0 }
				.compactMap { mapElement($0) }
			
			return PdfSubTablePair(
				key: element.label,
				value: values.joined(separator: ", ")
			)
		}

		if element is ReferenceValue,
		   let value = (element as? ReferenceValue)?.display {
			return PdfSubTablePair(key: element.label, value: value)
		}
		return nil
	}
	
	/// Map a UIElement onto a PDF sub table pair
	/// - Parameter element: the element
	/// - Returns: PDF sub table pair
	@MainActor private func mapElement(_ element: SingleValueDisplay) -> String? {
		
		switch element {
			case let .string(value):
				return value
			case let .displayCoding(displayCoding):
				return displayCoding.display
		}
	}
}
