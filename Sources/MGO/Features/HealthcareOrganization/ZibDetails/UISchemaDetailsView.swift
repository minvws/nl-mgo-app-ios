/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import Zibs

struct UISchemaDetailsView: View {
	
	/// The schema
	var schema: UISchema
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let padding: CGFloat = 8
			static let bottom: CGFloat = 16
			static let cornerRadius: CGFloat = 8
		}
		enum Row {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 4
		}
	}
	
	var body: some View {
		VStack(spacing: ViewTraits.List.padding) {
			ForEach(schema.children, id: \.self) { schemaGroup in
				viewFor(schemaGroup)
			}
		}
	}
	
	// MARK: - viewFor methods -
	
	/// Show a block of rows
	/// - Parameter schemaGroup: the schemaGroup to display
	/// - Returns: block of rows
	@ViewBuilder func viewFor(_ schemaGroup: UISchemaGroup) -> some View {
		
		// Section label
		Text(.init(stringLiteral: schemaGroup.label))
			.rijksoverheidStyle(font: .bold, style: .body)
			.foregroundStyle(theme.contentPrimary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityAddTraits(.isHeader)
		
		// List of elements
		VStack(alignment: .leading) {
			ForEach(schemaGroup.children, id: \.self) { childElement in
				viewFor(childElement, isLastElement: childElement == schemaGroup.children.last)
			}
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.background(theme.backgroundSecondary)
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.List.cornerRadius))
		.padding(.bottom, ViewTraits.List.bottom)
	}
	
	/// Show a row of data for each child display
	/// - Parameters:
	///   - childElement: the childElement to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a groupChild
	@ViewBuilder func viewFor(_ childElement: ChildElement, isLastElement: Bool) -> some View {
		
		Group {
			switch childElement.display {
				case .string(let value):
					viewFor(value, heading: heading(childElement), showDivider: !isLastElement)
					
				case .unionArray(let displayElements):
					viewFor(displayElements, childElement: childElement, isLastElement: isLastElement)
					
				case .none:
					viewFor(String(localized: "common.unknown"), heading: heading(childElement), showDivider: !isLastElement)
			}
		}
		.when(childElement.reference != nil) { view in
			view
				.onTapGesture {
					_ = logInfo("Tapped on", childElement.reference as Any)
				}
				.accessibilityAddTraits(.isButton)
				.accessibilityRemoveTraits(.isStaticText)
				.accessibilityIdentifier(childElement.label)
		}
	}
	
	/// Get the view for an array of DisplayElements
	/// - Parameters:
	///   - displayElements: the array of displayElements to be displayed.
	///   - childElement: The parent childElement for the heading
	///   - isLastElement: True if this is the last element in the array of ChildElements
	/// - Returns: view for the array of DisplayElements
	@ViewBuilder func viewFor(_ displayElements: [DisplayElement], childElement: ChildElement, isLastElement: Bool) -> some View {

		let singleValue = getSingleValuesValue(displayElements)
		if singleValue.isNotEmpty {
			viewFor(singleValue, heading: heading(childElement), showDivider: !isLastElement)
		}
		
		let multipleValues = getMultipleValuesValue(displayElements)
		ForEach(multipleValues, id: \.self) { multipleValue in
			viewFor(multipleValue, heading: heading(childElement), showDivider: !(isLastElement && multipleValue == multipleValues.last))
		}
	}
	
	/// Show a row of data (heading and value)
	/// - Parameters:
	///   - value: the value to display
	///   - heading: the heading to display
	///   - showDivider: True if we should show a divider at the bottom
	/// - Returns: Row View
	@ViewBuilder func viewFor(_ value: String, heading: String, showDivider: Bool = true) -> some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.Row.spacing) {
			
			Text(heading)
				.rijksoverheidStyle(font: .regular, style: .callout)
				.foregroundStyle(theme.contentTertiary)
			
			Text(Sanitizer.strip(value) ?? "common.unknown")
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
		}
		.padding(ViewTraits.Row.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.accessibilityElement(children: .combine)
		
		if showDivider {
			Divider()
				.frame(height: 1)
				.overlay(theme.strokesPrimary)
		}
	}
	
	// MARK: - private helpers -
	
	/// Get the heading for a row
	/// - Parameters:
	///   - childElement: the childElement
	/// - Returns: type text if heading is not in the language file. heading if it is.
	private func heading(_ childElement: ChildElement) -> String {
		
		return NSLocalizedString(
			childElement.label,
			value: "fhir." + (childElement.label.split(separator: ".").last ?? "unknown"),
			comment: ""
		)
	}
	
	/// Get the concatenated single value from an array of DisplayElements
	/// - Parameter displayElements: the array of DisplayElements to get the value from
	/// - Returns: Concatenated string of the single values
	private func getSingleValuesValue(_ displayElements: [DisplayElement]) -> String {
		
		var singleValues = [String]()
		for displayElement in displayElements {
			if case let .string(string) = displayElement {
				singleValues.append(string)
			}
		}
		return singleValues.joined(separator: ", ")
	}
	
	/// Get an array of concatenated multipleGroupValues from an array of DisplayElements
	/// - Parameter displayElements: the array of DisplayElements to get the value from
	/// - Returns: An array of Strings
	private func getMultipleValuesValue(_ displayElements: [DisplayElement]) -> [String] {
		
		var result = [String]()
		for displayElement in displayElements {
			if case let .stringArray(stringArray) = displayElement {
				result.append(stringArray.joined(separator: ", "))
			}
		}
		return result
	}
}
