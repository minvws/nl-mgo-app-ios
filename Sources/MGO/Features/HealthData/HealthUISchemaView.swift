/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

// swiftlint:disable type_body_length
struct HealthUISchemaView: View {
	
	/// The schema
	var schema: HealthUISchema
	
	/// The healthcare organization
	var healthcareOrganization: MgoOrganization
	
	/// Handler when a user taps on a reference
	var referenceTapped: ((String?) -> Void)?
	
	/// An array with the state of references
	var resolvedReferences: [String: Bool]
	
	/// Handler when a user taps on a code
	var codeTapped: ((DisplayValue?) -> Void)?
	
	/// An array with the state of codes
	var resolvedCodes: [String: Bool]
	
	let unknown = String(localized: "common.unknown")
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let padding: CGFloat = 8
			static let bottom: CGFloat = 16
			static let cornerRadius: CGFloat = 12
		}
		enum Row {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 4
		}
		enum Divider {
			static let height: CGFloat = 0.33
		}
		enum Chevron {
			static let size: CGFloat = 32.0
		}
		enum QuestionMark {
			static let size: CGFloat = 24
		}
	}
	
	var body: some View {
		VStack(spacing: ViewTraits.List.padding) {
			// A HealthUISchema consists of an array of schema groups (blocks of correlated data)
			ForEach(schema.children, id: \.self) { schemaGroup in
				viewFor(schemaGroup)
			}
		}
	}
	
	// MARK: - viewFor methods -
	
	/// Get the view for a schema group
	/// - Parameter schemaGroup: the schema group to display
	/// - Returns: block view
	@ViewBuilder private func viewFor(_ schemaGroup: HealthUIGroup) -> some View {
		
		if let schemaGroupLabel = schemaGroup.label {
			// A schema group has a section label
			Text(NSLocalizedString(schemaGroupLabel, comment: ""))
				.rijksoverheidStyle(font: .bold, style: .body)
				.foregroundStyle(theme.labels.primary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
		}
		
		// List of UIElementsProtocol
		VStack(alignment: .leading, spacing: 0) {
			
			// A schema group consists of an array of UIElementProtocol structs
			ForEach(Array(schemaGroup.uiElements.enumerated()), id: \.offset) { _, element in
				viewFor(element, isLastElement: element.elementType == schemaGroup.uiElements.last?.elementType && element.label == schemaGroup.uiElements.last?.label)
			}
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.background(theme.backgrounds.secondary)
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.List.cornerRadius))
		.padding(.bottom, ViewTraits.List.bottom)
	}
	
	/// Show a row of key: value for a UIElement
	/// - Parameters:
	///   - entry: the UIElement to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a UIElement
	@ViewBuilder private func viewFor(
		_ entry: UIElementProtocol,
		isLastElement: Bool
	) -> some View {
		
		switch entry {
			case is SingleValue:
				viewFor(entry as! SingleValue, isLastElement: isLastElement) // swiftlint:disable:this force_cast
			case is MultipleValues:
				viewFor(entry as! MultipleValues, isLastElement: isLastElement) // swiftlint:disable:this force_cast
			case is MultipleGroupedValues:
				viewFor(entry as! MultipleGroupedValues, isLastElement: isLastElement) // swiftlint:disable:this force_cast
			case is ReferenceLink:
				viewFor(entry as! ReferenceLink, isLastElement: isLastElement) // swiftlint:disable:this force_cast
			case is ReferenceValue:
				viewFor(entry as! ReferenceValue, isLastElement: isLastElement) // swiftlint:disable:this force_cast
			case is DownloadBinary:
				viewFor(entry as! DownloadBinary, isLastElement: isLastElement) // swiftlint:disable:this force_cast
			case is DownloadLink:
				viewFor(entry as! DownloadLink, isLastElement: isLastElement) // swiftlint:disable:this force_cast
			default:
				EmptyView()
					.logWarning("UISchemaView - unknown type", entry.elementType)
		}
	}
	
	/// Show a row of key: value for a Single Value entry
	/// - Parameters:
	///   - singleValue: the Single Value entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Single Value entry
	@ViewBuilder private func viewFor(
		_ singleValue: SingleValue,
		isLastElement: Bool
	) -> some View {
		
		if let value = singleValue.value {
			viewFor([value], heading: singleValue.label, showDivider: !isLastElement)
		}
	}
	
	/// Show a row of key: value for a Multiple Values entry
	/// - Parameters:
	///   - multipleValues: the Multiple Values entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Multiple Values entry
	@ViewBuilder private func viewFor(
		_ multipleValues: MultipleValues,
		isLastElement: Bool
	) -> some View {
		
		if let values = multipleValues.value {
			viewFor(values, heading: multipleValues.label, showDivider: !isLastElement)
		}
	}
	
	/// Show a row of key: value for a Multiple Grouped Values entry
	/// - Parameters:
	///   - multipleGroupedValues: the Multiple Grouped Values entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Multiple Grouped Values entry
	@ViewBuilder private func viewFor(
		_ multipleGroupedValues: MultipleGroupedValues,
		isLastElement: Bool
	) -> some View {
		
		if let values = multipleGroupedValues.value {
			let elements = values.flatMap({ $0 })
			viewFor(
				elements,
				heading: multipleGroupedValues.label,
				showDivider: !(isLastElement && elements == values.last)
			)
		}
	}
	
	/// Show a row of key: value for a Reference Link
	/// - Parameters:
	///   - referenceLink: the Reference Link entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Reference Link entry
	@ViewBuilder private func viewFor(
		_ referenceLink: ReferenceLink,
		isLastElement: Bool
	) -> some View {
		
		if resolvedReferences[referenceLink.reference] == true {
			// Reference Link to details page
			Button {
				self.referenceTapped?(referenceLink.reference)
			} label: {
				viewFor(
					referenceLink.label,
					heading: nil,
					showChevron: true,
					showDivider: !isLastElement
				)
			}
			.buttonStyle(HoverButtonStyle())
			.accessibilityIdentifier(referenceLink.label)
			
		} else {
			viewFor(
				SingleValue(
					label: referenceLink.label,
					type: .singleValue,
					value: DisplayValue(
						code: nil,
						display: referenceLink.reference,
						system: nil
					)
				),
				isLastElement: isLastElement
			)
		}
	}
	
	/// Show a row of key: value for a Reference Value
	/// - Parameters:
	///   - referenceValue: the Reference Value entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Reference Value entry
	@ViewBuilder private func viewFor(
		_ referenceValue: ReferenceValue,
		isLastElement: Bool
	) -> some View {
		
		let value = referenceValue.display ?? referenceValue.reference
		
		if let reference = referenceValue.reference,
		   resolvedReferences[reference] == true {
			
			Button {
				self.referenceTapped?(reference)
			} label: {
				viewFor(
					value,
					heading: referenceValue.label,
					showChevron: true,
					showDivider: !isLastElement
				)
			}
			.buttonStyle(HoverButtonStyle())
			.accessibilityIdentifier("\(referenceValue.label), \(value ?? "")")
			
		} else {
			viewFor(
				SingleValue(
					label: referenceValue.label,
					type: .singleValue,
					value: DisplayValue(
						code: nil,
						display: value,
						system: nil
					)
				),
				isLastElement: isLastElement
			)
		}
	}
	
	/// Show a row of key: value for a Download Binary entry
	/// - Parameters:
	///   - entry: the Download Binary entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Download Binary entry
	@ViewBuilder private func viewFor(
		_ downloadBinary: DownloadBinary,
		isLastElement: Bool
	) -> some View {
		
		HealthDataDownloadView(
			viewModel:
				HealthDataDownloadViewModel(
					healthcareOrganization: healthcareOrganization,
					downloadBinary: downloadBinary
				)
		)
		.when(!isLastElement) { view in
			
			HStack(alignment: .center, spacing: 0) {
				view
				Divider()
					.frame(height: ViewTraits.Divider.height)
					.overlay(theme.separators.primary)
					.padding(.leading, ViewTraits.Row.padding)
			}
		}
	}
	
	/// Show a row of key: value for a Download Link entry
	/// - Parameters:
	///   - entry: the Download Link entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Download Link entry
	@ViewBuilder private func viewFor(
		_ downloadLink: DownloadLink,
		isLastElement: Bool
	) -> some View {
		
		HealthDataDownloadView(
			viewModel:
				HealthDataDownloadViewModel(
					healthcareOrganization: healthcareOrganization,
					downloadLink: downloadLink
				)
		)
		.when(!isLastElement) { view in
			
			HStack(alignment: .center, spacing: 0) {
				view
				Divider()
					.frame(height: ViewTraits.Divider.height)
					.overlay(theme.separators.primary)
					.padding(.leading, ViewTraits.Row.padding)
			}
		}
	}
	
	/// Show a row of data (heading and value)
	/// - Parameters:
	///   - value: the value to display
	///   - heading: the heading to display
	///   - showDivider: True if we should show a divider at the bottom
	/// - Returns: Row View
	@ViewBuilder private func viewFor(
		_ value: String?,
		heading: String?,
		showChevron: Bool = false,
		showDivider: Bool = true
	) -> some View {
		
		HStack(alignment: .center, spacing: 0) {
			
			VStack(alignment: .leading, spacing: ViewTraits.Row.spacing) {
				
				if let heading {
					viewFor(heading, accessibilityIdentifier: heading)
				}
				let text = Sanitizer.strip(value) ?? unknown
				Text(text)
					.rijksoverheidStyle(font: .regular, style: .body)
					.accessibilityIdentifier(text)
			}
			
			Spacer()
			
			if showChevron {
				
				Image(ImageResource.Overview.chevronRight)
					.foregroundStyle(theme.symbols.primary)
					.frame(width: ViewTraits.Chevron.size,
						   height: ViewTraits.Chevron.size,
						   alignment: .center
					)
					.accessibilityHidden(true)
			}
		}
		.padding(ViewTraits.Row.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		
		if showDivider {
			Divider()
				.frame(height: ViewTraits.Divider.height)
				.overlay(theme.separators.primary)
				.padding(.leading, ViewTraits.Row.padding)
		}
	}
	
	/// A Selectable Text View
	/// - Parameter value: the display value
	/// - Returns: view
	@ViewBuilder private func selectableTextView(_ value: String) -> some View {
		
		SelectableTextView(
			text: value,
			textColor: theme.labels.primary,
			font: UIFont(
				name: RijksoverheidSansWebTextFont.regular.fontName,
				size: Font.TextStyle.body.pointSize
			)
		)
	}
	
	/// Show a row of data (ValueDisplay)
	/// - Parameters:
	///   - value: the value to display
	///   - heading: the heading to display
	///   - showDivider: True if we should show a divider at the bottom
	/// - Returns: Row View
	@ViewBuilder private func viewFor(
		_ values: [DisplayValue],
		heading: String?,
		showDivider: Bool
	) -> some View {
		
		HStack(alignment: .center, spacing: 0) {
			
			VStack(alignment: .leading, spacing: ViewTraits.Row.spacing) {
				
				if let heading {
					viewFor(heading, accessibilityIdentifier: heading)
				}
				viewFor(values)
			}
		}
		.padding(ViewTraits.Row.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		
		if showDivider {
			Divider()
				.frame(height: ViewTraits.Divider.height)
				.overlay(theme.separators.primary)
				.padding(.leading, ViewTraits.Row.padding)
		}
	}
	
	/// The view for an array of value displays
	/// - Parameter element: the array of value displays
	/// - Returns: view for the array of value displays
	@ViewBuilder private func viewFor(_ values: [DisplayValue]) -> some View {
		
		ForEach(Array(values.enumerated()), id: \.offset) { _, element in
			viewFor(element)
		}
	}
	
	/// The view for a value display
	/// - Parameter element: the value display
	/// - Returns: view for value display
	@ViewBuilder private func viewFor(_ element: DisplayValue) -> some View {
		
		if let code = element.code, resolvedCodes[code] ?? false {
			termViewFor(element)
				.accessibilityIdentifier(code)
		} else {
			selectableTextView(Sanitizer.strip(element.display) ?? unknown)
				.accessibilityIdentifier(element.code ?? "unknown")
		}
	}
	
	/// The view for a display coding
	/// - Parameter displayValue: the coding object
	/// - Returns: view for display coding
	@ViewBuilder private func termViewFor(_ displayValue: DisplayValue) -> some View {
		
		Button {
			codeTapped?(displayValue)
		} label: {
			displayCodingLabel(Sanitizer.strip(displayValue.display) ?? unknown)
		}
		.buttonStyle(HalfOpacityWhenPressedButtonStyle())
		.accessibilityIdentifier(displayValue.code ?? "unknown")
	}
	
	/// The label for a patient friendly term
	/// - Parameter text: the term
	/// - Returns: view for the label of a term (with question mark icon)
	@ViewBuilder private func displayCodingLabel(_ text: String) -> some View {
		
		HStack(alignment: .center, content: {
			
			Label {
				Text(text)
					.rijksoverheidStyle(font: .regular, style: .body)
					.backport.underline(pattern: .dot)
			} icon: {
				Image(systemName: "questionmark.circle")
					.resizable()
					.frame(
						width: ViewTraits.QuestionMark.size,
						height: ViewTraits.QuestionMark.size
					)
			}
			.labelStyle(TrailingIconLabelStyle())
			
			Spacer()
		})
		.fixedSize(horizontal: false, vertical: true)
		.foregroundStyle(theme.categories.rijkslint)
	}
	
	/// The view for a heading row
	/// - Parameter heading: the heading
	/// - Parameter accessibilityIdentifier: the accessibility Identifier
	/// - Returns: heading view
	@ViewBuilder private func viewFor(
		_ heading: String,
		accessibilityIdentifier: String
	) -> some View {
		
		SelectableTextView(
			text: heading,
			textColor: theme.labels.secondary,
			font: UIFont(
				name: RijksoverheidSansWebTextFont.regular.fontName,
				size: Font.TextStyle.callout.pointSize
			)
		)
		.accessibilityIdentifier(accessibilityIdentifier)
		.accessibilityAddTraits(.isHeader)
	}
}
// swiftlint:enable type_body_length

#Preview {
	ScrollView {
		HealthUISchemaView(
			schema: PreviewContent.uiSchema,
			healthcareOrganization: PreviewContent.healthcareOrganization,
			resolvedReferences: ["reference": true],
			resolvedCodes: ["code": true]
		)
		.padding(.horizontal, 16)
	}
}
