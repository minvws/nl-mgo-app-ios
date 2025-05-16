/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct HealthUISchemaView: View {
	
	/// The schema
	var schema: HealthUISchema
	
	/// The healthcare organization
	var healthcareOrganization: MgoOrganization
	
	/// Handler when a user taps on a reference
	var referenceTapped: ((String?) -> Void)?
	
	/// An array with the state of references
	var resolvedReferences: [String: Bool]
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let padding: CGFloat = 8
			static let bottom: CGFloat = 16
			static let cornerRadius: CGFloat = 10
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
				.foregroundStyle(theme.contentPrimary)
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
		.background(theme.backgroundSecondary)
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.List.cornerRadius))
		.padding(.bottom, ViewTraits.List.bottom)
	}
	
	/// Show a row of key: value for a UIElement
	/// - Parameters:
	///   - entry: the UIElement to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a UIElement
	@ViewBuilder private func viewFor(_ entry: UIElementProtocol, isLastElement: Bool) -> some View {
		
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
//				Text(entry.elementType)
				EmptyView()
		}
	}

	/// Show a row of key: value for a Single Value entry
	/// - Parameters:
	///   - singleValue: the Single Value entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Single Value entry
	@ViewBuilder private func viewFor(_ singleValue: SingleValue, isLastElement: Bool) -> some View {
		
		let value = singleValue.display
		viewFor(value, heading: singleValue.label, showDivider: !isLastElement)
	}
	
	/// Show a row of key: value for a Multiple Values entry
	/// - Parameters:
	///   - multipleValues: the Multiple Values entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Multiple Values entry
	@ViewBuilder private func viewFor(_ multipleValues: MultipleValues, isLastElement: Bool) -> some View {
		
		let value = multipleValues.display?.joined(separator: ", ")
		viewFor(value, heading: multipleValues.label, showDivider: !isLastElement)
	}

	/// Show a row of key: value for a Multiple Grouped Values entry
	/// - Parameters:
	///   - multipleGroupedValues: the Multiple Grouped Values entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Multiple Grouped Values entry
	@ViewBuilder private func viewFor(_ multipleGroupedValues: MultipleGroupedValues, isLastElement: Bool) -> some View {
		
		if let display = multipleGroupedValues.display {
			ForEach(Array(display.enumerated()), id: \.offset) { index, element in
				let value = element.joined(separator: ", ")
				viewFor(value, heading: multipleGroupedValues.label, showDivider: !(isLastElement && element == display.last))
			}
		} else {
			EmptyView()
		}
	}
	
	/// Show a row of key: value for a Reference Link
	/// - Parameters:
	///   - referenceLink: the Reference Link entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Reference Link entry
	@ViewBuilder private func viewFor(_ referenceLink: ReferenceLink, isLastElement: Bool) -> some View {
		
		if resolvedReferences[referenceLink.reference] == true {
			// Reference Link to details page
			Button {
				self.referenceTapped?(referenceLink.reference)
			} label: {
				viewFor(
					referenceLink.label,
					heading: nil,
					showDivider: !isLastElement,
					showChevron: true
				)
			}
			.buttonStyle(HoverButtonStyle())
			.accessibilityIdentifier(referenceLink.label)
			
		} else {
			viewFor(referenceLink.reference, heading: referenceLink.label, showDivider: !isLastElement)
		}
	}
	
	/// Show a row of key: value for a Reference Value
	/// - Parameters:
	///   - referenceValue: the Reference Value entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Reference Value entry
	@ViewBuilder private func viewFor(_ referenceValue: ReferenceValue, isLastElement: Bool) -> some View {
		
		if let reference = referenceValue.reference,
			resolvedReferences[reference] == true,
			let display = referenceValue.display {

			Button {
				self.referenceTapped?(reference)
			} label: {
				viewFor(
					display,
					heading: referenceValue.label,
					showDivider: !isLastElement,
					showChevron: true
				)
			}
			.buttonStyle(HoverButtonStyle())
			.accessibilityIdentifier(referenceValue.label)
			
		} else {
			viewFor(
				referenceValue.display ?? referenceValue.reference,
				heading: referenceValue.label,
				showDivider: !isLastElement
			)
		}
	}
	
	/// Show a row of key: value for a Download Binary entry
	/// - Parameters:
	///   - entry: the Download Binary entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Download Binary entry
	@ViewBuilder private func viewFor(_ downloadBinary: DownloadBinary, isLastElement: Bool) -> some View {
		
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
					.overlay(theme.borderPrimary)
					.padding(.leading, ViewTraits.Row.padding)
			}
		}
	}
	
	/// Show a row of key: value for a Download Link entry
	/// - Parameters:
	///   - entry: the Download Link entry to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a Download Link entry
	@ViewBuilder private func viewFor(_ downloadLink: DownloadLink, isLastElement: Bool) -> some View {
		
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
					.overlay(theme.borderPrimary)
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
	@ViewBuilder func viewFor(_ value: String?, heading: String?, showDivider: Bool = true, showChevron: Bool = false) -> some View {
		
		HStack(alignment: .center, spacing: 0) {
			
			VStack(alignment: .leading, spacing: ViewTraits.Row.spacing) {
				
				if let heading {
					Text(heading)
						.rijksoverheidStyle(font: .regular, style: .callout)
						.foregroundStyle(theme.contentSecondary)
				}
				
				Text(Sanitizer.strip(value) ?? String(localized: "common.unknown"))
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentPrimary)
			}
			
			if showChevron {
				
				Spacer()
				
				Image(ImageResource.Overview.chevronRight)
					.foregroundStyle(theme.symbolPrimary)
					.frame(width: ViewTraits.Chevron.size, height: ViewTraits.Chevron.size, alignment: .center)
					.accessibilityHidden(true)
			}
		}
		.textSelection(.enabled)
		.padding(ViewTraits.Row.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.accessibilityElement(children: .combine)
		
		if showDivider {
			Divider()
				.frame(height: ViewTraits.Divider.height)
				.overlay(theme.borderPrimary)
				.padding(.leading, ViewTraits.Row.padding)
		}
	}
}

#Preview {
	ScrollView {
		HealthUISchemaView(
			schema: PreviewContent.uiSchema,
			healthcareOrganization: PreviewContent.healthcareOrganization,
			resolvedReferences: ["reference": true]
		)
		.padding(.horizontal, 16)
	}
}
