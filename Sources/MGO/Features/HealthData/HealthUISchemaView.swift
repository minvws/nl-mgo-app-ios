/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

// swiftlint:disable type_body_length
struct HealthUISchemaView: View {
	
	/// The schema
	var schema: HealthUISchema
	
	/// The healthcare organization
	var healthcareOrganization: OrganizationSearch.Organization
	
	/// Handler when a user taps on a reference
	var referenceTapped: ((String?) -> Void)?
	
	/// An array with the state of references
	var resolvedReferences: [String: Bool]
	
	/// Handler when a user taps on a code
	var codeTapped: ((DisplayValue?) -> Void)?
	
	/// An array with the state of codes
	var resolvedCodes: [String: Bool]
	
	let unknown = String(localized: "common.unknown")

	@State private var showToolbarTitle = false

	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Magic Numbers
	private struct ViewTraits {
		enum List {
			static let headerInset: EdgeInsets = EdgeInsets(top: 2, leading: 16, bottom: 2, trailing: 16)
			static let alternativeInset = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
			static let inset: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
			static let zeroInset: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let bottom: CGFloat = 16
			static let categoryHeaderTopPadding: CGFloat = 24
			static let categoryHeaderBottomPadding: CGFloat = 10
		}
		enum Row {
			static let spacing: CGFloat = 4
			static let padding: CGFloat = 12
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum Chevron {
			static let size: CGFloat = 32.0
		}
		enum QuestionMark {
			static let size: CGFloat = 20.0
		}
		enum Title {
			static let duration: Double = 0.2
		}
	}

	var body: some View {

		List {
			Section {
				titleSection
			}
			// A HealthUISchema consists of an array of schema groups
			// (blocks of correlated data)
			ForEach(schema.children, id: \.self) { schemaGroup in
				viewFor(schemaGroup)
			}
		}
		.backport.listSectionSpacing(osVersionChecker.available(version: .iOS(.v26)) ? 0 : 4)
		.backport.contentMargins(0)
		.backport.scrollContentBackground(.hidden)
		.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar { toolbarContent }
	}
	
	// MARK: - Title helper -
	
	/// Inline navigation bar title that fades in once the in-content title has scrolled out of view.
	@ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .principal) {
			Text(schema.label)
				.typography(.bodyMedium, with: .bold)
				.lineLimit(2)
				.multilineTextAlignment(.center)
				.opacity(showToolbarTitle ? 1 : 0)
				.fixedSize(horizontal: false, vertical: true)
		}
	}
	
	/// Large in-content title row. Triggers toolbar title visibility via `onAppear`/`onDisappear`.
	@ViewBuilder private var titleSection: some View {
		
		Text(schema.label)
			.typography(.headingLarge)
			.multilineTextAlignment(.leading)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding()
			.listRowInsets(.init())
			.listRowSeparator(.hidden)
			.listRowBackground(Color.clear)
			.onAppear {
				withAnimation(
					.easeInOut(duration: ViewTraits.Title.duration)
				) {
					showToolbarTitle = false
				}
			}
			.onDisappear {
				withAnimation(
					.easeInOut(duration: ViewTraits.Title.duration)
				) {
					showToolbarTitle = true
				}
			}
	}
	
	// MARK: - viewFor methods -
	
	/// Get the view for a schema group
	/// - Parameter schemaGroup: the schema group to display
	/// - Returns: block view
	@ViewBuilder private func viewFor(_ schemaGroup: HealthUIGroup) -> some View {
		
		let isFirstSchemaGroup = schemaGroup == schema.children.first
		
		if let schemaGroupLabel = schemaGroup.label {
			Section {
				// A schema group has a section label
				Text(NSLocalizedString(schemaGroupLabel, comment: ""))
					.typography(.headingMedium)
					.foregroundStyle(theme.labels.primary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.padding(.top, isFirstSchemaGroup ? 0 : ViewTraits.List.categoryHeaderTopPadding
					)
					.padding(.bottom, ViewTraits.List.categoryHeaderBottomPadding)
			}
			.listRowBackground(Color.clear)
			.listRowInsets(
				headerInset(
					first: isFirstSchemaGroup
				)
			)
		}
		// A schema group consists of an array of UIElementProtocol structs
		Section {
			ForEach(schemaGroup.uiElements.indices, id: \.self) { index in
				viewFor(schemaGroup.uiElements[index])
			}
		} footer: {
			if schemaGroup == schema.children.last {
				Rectangle()
					.fill(.clear)
					.frame(height: ViewTraits.List.bottom)
			}
		}
	}
	
	/// The inset for the header
	/// - Parameter first: is this the first header
	/// - Returns: the inset for the header
	func headerInset(first: Bool) -> EdgeInsets {
		
		guard osVersionChecker.available(version: .iOS(.v17)) else {
			return ViewTraits.List.zeroInset
		}
		
		var inset: EdgeInsets = ViewTraits.List.headerInset
		
		if first {
			inset = ViewTraits.List.alternativeInset
		}
		
		inset.leading = osVersionChecker
			.available(version: .iOS(.v26)) ? ViewTraits.General.padding : 0
		
		return inset
	}
	
	/// Show a row of key: value for a UIElement
	/// - Parameters:
	///   - entry: the UIElement to display
	/// - Returns: view for a UIElement
	@ViewBuilder private func viewFor(
		_ entry: UIElementProtocol
	) -> some View {
		
		switch entry {
			case is SingleValue:
				viewFor(entry as! SingleValue) // swiftlint:disable:this force_cast
			case is MultipleValues:
				viewFor(entry as! MultipleValues) // swiftlint:disable:this force_cast
			case is MultipleGroupedValues:
				viewFor(entry as! MultipleGroupedValues) // swiftlint:disable:this force_cast
			case is ReferenceLink:
				viewFor(entry as! ReferenceLink) // swiftlint:disable:this force_cast
			case is ReferenceValue:
				viewFor(entry as! ReferenceValue) // swiftlint:disable:this force_cast
			case is DownloadBinary:
				viewFor(entry as! DownloadBinary) // swiftlint:disable:this force_cast
			case is DownloadLink:
				viewFor(entry as! DownloadLink) // swiftlint:disable:this force_cast
			default:
				EmptyView()
					.logWarning("UISchemaView - unknown type", entry.elementType)
		}
	}
	
	/// Show a row of key: value for a Single Value entry
	/// - Parameters:
	///   - singleValue: the Single Value entry to display
	/// - Returns: view for a Single Value entry
	@ViewBuilder private func viewFor(
		_ singleValue: SingleValue
	) -> some View {
		
		if let value = singleValue.value {
			viewFor([value], heading: singleValue.label)
		}
	}
	
	/// Show a row of key: value for a Multiple Values entry
	/// - Parameters:
	///   - multipleValues: the Multiple Values entry to display
	/// - Returns: view for a Multiple Values entry
	@ViewBuilder private func viewFor(
		_ multipleValues: MultipleValues,
	) -> some View {
		
		if let values = multipleValues.value {
			viewFor(values, heading: multipleValues.label)
		}
	}
	
	/// Show a row of key: value for a Multiple Grouped Values entry
	/// - Parameters:
	///   - multipleGroupedValues: the Multiple Grouped Values entry to display
	/// - Returns: view for a Multiple Grouped Values entry
	@ViewBuilder private func viewFor(
		_ multipleGroupedValues: MultipleGroupedValues,
	) -> some View {
		
		if let values = multipleGroupedValues.value {
			let elements = values.flatMap({ $0 })
			viewFor(
				elements,
				heading: multipleGroupedValues.label
			)
		}
	}
	
	/// Show a row of key: value for a Reference Link
	/// - Parameters:
	///   - referenceLink: the Reference Link entry to display
	/// - Returns: view for a Reference Link entry
	@ViewBuilder private func viewFor(
		_ referenceLink: ReferenceLink
	) -> some View {
		
		if resolvedReferences[referenceLink.reference] == true {
			// Reference Link to details page
			Button {
				self.referenceTapped?(referenceLink.reference)
			} label: {
				viewFor(
					referenceLink.label,
					heading: nil,
					showChevron: true
				)
				.padding(.vertical, osVersionChecker.available(version: .iOS(.v26)) ? 0 : 16)
			}
			.accessibilityIdentifier(referenceLink.label)
			
		} else {
			viewFor(
				SingleValue(
					id: referenceLink.id,
					label: referenceLink.label,
					type: .singleValue,
					value: DisplayValue(
						code: nil,
						display: referenceLink.reference,
						system: nil
					)
				)
			)
		}
	}
	
	/// Show a row of key: value for a Reference Value
	/// - Parameters:
	///   - referenceValue: the Reference Value entry to display
	/// - Returns: view for a Reference Value entry
	@ViewBuilder private func viewFor(
		_ referenceValue: ReferenceValue,
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
					showChevron: true
				)
				.padding(.vertical, osVersionChecker.available(version: .iOS(.v26)) ? 0 : 16)
			}
			.accessibilityIdentifier("\(referenceValue.label), \(value ?? "")")
			
		} else {
			viewFor(
				SingleValue(
					id: referenceValue.id,
					label: referenceValue.label,
					type: .singleValue,
					value: DisplayValue(
						code: nil,
						display: value,
						system: nil
					)
				)
			)
		}
	}
	
	/// Show a row of key: value for a Download Binary entry
	/// - Parameters:
	///   - entry: the Download Binary entry to display
	/// - Returns: view for a Download Binary entry
	@ViewBuilder private func viewFor(
		_ downloadBinary: DownloadBinary,
	) -> some View {
		
		HealthDataDownloadView(
			viewModel:
				HealthDataDownloadViewModel(
					healthcareOrganization: healthcareOrganization,
					downloadBinary: downloadBinary
				)
		)
		.listRowInsets(ViewTraits.List.zeroInset)
	}
	
	/// Show a row of key: value for a Download Link entry
	/// - Parameters:
	///   - entry: the Download Link entry to display
	/// - Returns: view for a Download Link entry
	@ViewBuilder private func viewFor(
		_ downloadLink: DownloadLink,
	) -> some View {
		
		HealthDataDownloadView(
			viewModel:
				HealthDataDownloadViewModel(
					healthcareOrganization: healthcareOrganization,
					downloadLink: downloadLink
				)
		)
		.listRowInsets(ViewTraits.List.zeroInset)
	}
	
	/// Show a row of data (heading and value)
	/// - Parameters:
	///   - value: the value to display
	///   - heading: the heading to display
	///   - showChevron: show a chevron
	/// - Returns: Row View
	@ViewBuilder private func viewFor(
		_ value: String?,
		heading: String?,
		showChevron: Bool = false
	) -> some View {
		
		HStack(alignment: .center, spacing: 0) {
			
			VStack(alignment: .leading, spacing: ViewTraits.Row.spacing) {
				
				if let heading {
					viewFor(heading, accessibilityIdentifier: heading)
				}
				let text = Sanitizer.strip(value) ?? unknown
				Text(text)
					.typography(.bodyMedium)
					.foregroundStyle(theme.labels.primary)
					.accessibilityIdentifier(text)
			}
			Spacer()
			
			if showChevron {
				
				Image(systemName: "chevron.right")
					.foregroundStyle(theme.symbols.primary)
					.frame(
						width: ViewTraits.Chevron.size,
						height: ViewTraits.Chevron.size,
						alignment: .center
					)
					.accessibilityHidden(true)
			}
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
				name: RijksoverheidFont.regular.fontName,
				size: Font.TextStyle.body.pointSize
			)
		)
	}
	
	/// Show a row of data (ValueDisplay)
	/// - Parameters:
	///   - value: the value to display
	///   - heading: the heading to display
	/// - Returns: Row View
	@ViewBuilder private func viewFor(
		_ values: [DisplayValue],
		heading: String?,
	) -> some View {
		
		VStack(alignment: .leading, spacing: 0) {
			
			if let heading {
				viewFor(heading, accessibilityIdentifier: heading)
			}
			viewFor(values)
		}
		.padding(.vertical, osVersionChecker.available(version: .iOS(.v26)) ? 8 : 16)
	}
	
	/// The view for an array of value displays
	/// - Parameter element: the array of value displays
	/// - Returns: view for the array of value displays
	@ViewBuilder private func viewFor(_ values: [DisplayValue]) -> some View {
		
		ForEach(Array(values.enumerated()), id: \.offset) { _, element in
			if let code = element.code, resolvedCodes[code] ?? false {
				termViewFor(element)
					.accessibilityIdentifier(code)
			} else {
				selectableTextView(Sanitizer.strip(element.display) ?? unknown)
					.accessibilityIdentifier(element.code ?? "unknown")
			}
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
					.typography(.bodyMedium)
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
				name: RijksoverheidFont.regular.fontName,
				size: Font.TextStyle.callout.pointSize
			)
		)
		.accessibilityIdentifier(accessibilityIdentifier)
		.accessibilityAddTraits(.isHeader)
		.padding(.bottom, osVersionChecker.available(version: OSVersion.iOS(.v26)) ? 0 : -8)
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
