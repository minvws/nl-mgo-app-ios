/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import Zibs

struct UISchemaView: View {
	
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
			// A UISchema consists of an array of schema groups (blocks of correlated data)
			ForEach(schema.children, id: \.self) { schemaGroup in
				viewFor(schemaGroup)
			}
		}
	}
	
	// MARK: - viewFor methods -
	
	/// Get the view for a schema group
	/// - Parameter schemaGroup: the schema group to display
	/// - Returns: block view
	@ViewBuilder func viewFor(_ schemaGroup: UISchemaGroup) -> some View {
		
		// A schema group has a section label
		Text(NSLocalizedString(schemaGroup.label, comment: ""))
			.rijksoverheidStyle(font: .bold, style: .body)
			.foregroundStyle(theme.contentPrimary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityAddTraits(.isHeader)
		
		// List of elements
		VStack(alignment: .leading) {
			// A schema group consists of an array of UIEntries
			ForEach(schemaGroup.children, id: \.self) { childElement in
				viewFor(childElement, isLastElement: childElement == schemaGroup.children.last)
			}
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.background(theme.backgroundSecondary)
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.List.cornerRadius))
		.padding(.bottom, ViewTraits.List.bottom)
	}
	
	/// Show a row of key: value for a UIEntry
	/// - Parameters:
	///   - entry: the UIEntry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a UIEntry
	@ViewBuilder func viewFor(_ entry: UIEntry, isLastElement: Bool) -> some View {
		
		if case .downloadLink = entry.type {
		
			CallToActionButton(title: entry.label, icon: Image(ImageResource.Schema.download), style: .primaryWithIcon) {
				// todo
			}
			
		} else {
			
			viewFor(entry.display, entry: entry, isLastElement: isLastElement)
				.when(entry.reference != nil) { view in
					view
						.onTapGesture {
							_ = logInfo("Tapped on", entry.reference as Any)
						}
						.accessibilityAddTraits(.isButton)
						.accessibilityRemoveTraits(.isStaticText)
						.accessibilityIdentifier(entry.label)
				}
				.when(entry.url != nil) { view in
					view
						.onTapGesture {
							_ = logInfo("Tapped on", entry.url as Any)
						}
						.accessibilityAddTraits(.isButton)
						.accessibilityRemoveTraits(.isStaticText)
						.accessibilityIdentifier(entry.label)
				}
		}
	}
	
	/// Get the row for a UIEntryDisplay
	/// - Parameters:
	///   - display: the UIEntryDisplay to display
	///   - entry: the parent UIEntry
	///   - isLastElement: True if this is the last element in the array of UIEntries
	/// - Returns: row for a UIEntry display
	@ViewBuilder func viewFor(_ display: UIEntryDisplay?, entry: UIEntry, isLastElement: Bool) -> some View {
		
		let heading = heading(entry)
		
		switch display {
			case .string(let value):
				viewFor(value, heading: heading, showDivider: !isLastElement)
				
			case .unionArray(let displayElements):
				viewFor(displayElements, entry: entry, isLastElement: isLastElement)
				
			case .none:
				viewFor(String(localized: "common.unknown"), heading: heading, showDivider: !isLastElement)
		}
	}
	
	/// Get the view for an array of DisplayElements
	/// - Parameters:
	///   - displayElements: the array of displayElements to be displayed.
	///   - childElement: The parent childElement for the heading
	///   - isLastElement: True if this is the last element in the array of ChildElements
	/// - Returns: view for the array of DisplayElements
	@ViewBuilder func viewFor(_ displayElements: [DisplayElement], entry: UIEntry, isLastElement: Bool) -> some View {

		let singleValue = getSingleValuesValue(displayElements)
		if singleValue.isNotEmpty {
			viewFor(singleValue, heading: heading(entry), showDivider: !isLastElement)
		}
		
		let multipleValues = getMultipleValuesValue(displayElements)
		ForEach(multipleValues, id: \.self) { multipleValue in
			viewFor(multipleValue, heading: heading(entry), showDivider: !(isLastElement && multipleValue == multipleValues.last))
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
		.textSelection(.enabled)
		.padding(ViewTraits.Row.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.accessibilityElement(children: .combine)
		
		if showDivider {
			Divider()
				.frame(height: 1)
				.overlay(theme.strokesPrimary)
				.padding(.leading, ViewTraits.Row.padding)
		}
	}
	
	// MARK: - private helpers -
	
	/// Get the heading for a row
	/// - Parameters:
	///   - entry: the UIEntry
	/// - Returns: type text if heading is not in the language file. heading if it is.
	private func heading(_ entry: UIEntry) -> String {
		
		return NSLocalizedString(
			entry.label,
			value: entry.label,
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

#Preview {
	UISchemaView(
		schema:
			UISchema(
				children: [
					// Schema Group 1
					UISchemaGroup(
						children: [
							UIEntry(
								display: UIEntryDisplay.string("single value"),
								label: "label single value",
								summary: true,
								type: .singleValue,
								reference: nil,
								url: nil
							),
							
							UIEntry(
								display: nil,
								label: "label reference",
								summary: true,
								type: .referenceValue,
								reference: "reference",
								url: nil
							),
							UIEntry(
								display: nil,
								label: "label download link",
								summary: true,
								type: .downloadLink,
								reference: nil,
								url: "https://www.apple.com"
							)
						],
						label: "Section Header first group"),
					
					// Schema Group 2
					UISchemaGroup(
						children: [
							// Unknown
							UIEntry(
								display: nil,
								label: "label single value nil",
								summary: true,
								type: .singleValue,
								reference: nil,
								url: nil
							)
							
						],
						label: "Section Header second group")
				],
				label: "UI Schema"
			)
	)
}
