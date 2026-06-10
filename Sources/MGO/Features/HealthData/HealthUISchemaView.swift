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

	/// Vertical scroll offset, used to fade in the toolbar title.
	@State private var scrollOffset: CGPoint = .zero

	/// Measured size of the in-content title block.
	@State private var titleSize: CGSize = .zero

	/// The Theme
	@Environment(\.mgoTheme) var theme

	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker

	/// Magic Numbers
	private enum Layout {
		static let screenMargin: CGFloat = 16
		static let cardPadding: CGFloat = 16
		static let cardRadiusNew: CGFloat = 26
		static let cardRadiusOld: CGFloat = 12
		static let rowVertical: CGFloat = 16
		static let labelValueSpacing: CGFloat = 4
		static let sectionHeaderTop: CGFloat = 24
		static let sectionHeaderBottom: CGFloat = 10
		static let interSectionGap: CGFloat = 16
		static let bottom: CGFloat = 16
		static let titleVertical: CGFloat = 16
		static let titleFadeDuration: Double = 0.2
		static let chevronSize: CGFloat = 32
		static let questionMarkSize: CGFloat = 20
		static let separatorHeight: CGFloat = 1
	}

	/// Leading inset for section headers and row text (card inset + internal padding).
	private var contentLeading: CGFloat { Layout.screenMargin + Layout.cardPadding }

	/// Card corner radius, larger/continuous on iOS 26.
	private var cardCornerRadius: CGFloat {
		osVersionChecker.available(version: .iOS(.v26)) ? Layout.cardRadiusNew : Layout.cardRadiusOld
	}

	var body: some View {

		OffsetObservingScrollView(bounces: true, offset: $scrollOffset) {
			scrollContent
		}
		.onChange(of: scrollOffset) { offset in
			withAnimation(.easeInOut(duration: Layout.titleFadeDuration)) {
				showToolbarTitle = HealthSchemaToolbarTitle.shouldShow(
					scrollOffsetY: offset.y,
					titleBlockHeight: titleSize.height
				)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar { toolbarContent }
	}

	/// The scrolling content. Extracted from `body` so the view tree stays within
	/// SwiftLint's result-builder nesting limit.
	@ViewBuilder private var scrollContent: some View {
		VStack(alignment: .leading, spacing: 0) {
			titleRow
			ForEach(schema.children, id: \.self) { schemaGroup in
				sectionView(for: schemaGroup)
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.bottom, Layout.bottom)
	}

	// MARK: - Title -

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

	/// Large in-content title row. Its height is measured so the toolbar title can
	/// fade in once it has scrolled out of view.
	@ViewBuilder private var titleRow: some View {
		Text(schema.label)
			.typography(.headingExtraLarge)
			.multilineTextAlignment(.leading)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.vertical, Layout.titleVertical)
			.padding(.horizontal, Layout.screenMargin)
			.readSize($titleSize)
	}

	// MARK: - Sections -

	/// Renders a schema group: an optional header followed by its content runs.
	@ViewBuilder private func sectionView(for group: HealthUIGroup) -> some View {
		let isFirst = group == schema.children.first
		if let label = group.label {
			sectionHeader(label, isFirst: isFirst)
		} else if !isFirst {
			Color.clear.frame(height: Layout.interSectionGap)
		}
		ForEach(Array(HealthSectionRun.runs(from: group.uiElements).enumerated()), id: \.offset) { index, run in
			sectionRunView(run)
				.padding(.top, index == 0 ? 0 : Layout.interSectionGap)
		}
	}

	/// A schema group's header. Sits outside the card, aligned with the row text.
	@ViewBuilder private func sectionHeader(_ label: String, isFirst: Bool) -> some View {
		Text(NSLocalizedString(label, comment: ""))
			.typography(.headingMedium)
			.foregroundStyle(theme.labels.primary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityAddTraits(.isHeader)
			.padding(.top, isFirst ? 0 : Layout.sectionHeaderTop)
			.padding(.bottom, Layout.sectionHeaderBottom)
			.padding(.leading, contentLeading)
			.padding(.trailing, Layout.screenMargin)
	}

	/// Renders a single layout run: a card of normal rows, or a full-width element.
	@ViewBuilder private func sectionRunView(_ run: HealthSectionRun) -> some View {
		switch run {
			case let .card(elements):
				cardView(elements)
			case let .fullWidth(element):
				viewFor(element)
		}
	}

	/// A rounded card containing a group's normal rows, separated by hairlines.
	@ViewBuilder private func cardView(_ elements: [UIElementProtocol]) -> some View {
		VStack(alignment: .leading, spacing: 0) {
			ForEach(elements.indices, id: \.self) { index in
				cardRow(elements[index], isLast: index == elements.count - 1)
			}
		}
		.background(theme.backgrounds.secondary)
		.clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
		.padding(.horizontal, Layout.screenMargin)
	}

	/// A single card row plus its trailing separator (omitted for the last row).
	@ViewBuilder private func cardRow(_ element: UIElementProtocol, isLast: Bool) -> some View {
		viewFor(element)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.vertical, Layout.rowVertical)
			.padding(.horizontal, Layout.cardPadding)
		if !isLast {
			separator
		}
	}

	/// A hairline row separator, leading-aligned with the row text.
	private var separator: some View {
		Rectangle()
			.fill(theme.separators.primary)
			.frame(height: Layout.separatorHeight)
			.padding(.leading, Layout.cardPadding)
	}

	// MARK: - viewFor methods -

	/// Get the view for a UIElement
	@ViewBuilder private func viewFor(_ entry: UIElementProtocol) -> some View {
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

	@ViewBuilder private func viewFor(_ singleValue: SingleValue) -> some View {
		if let value = singleValue.value {
			viewFor([value], heading: singleValue.label)
		}
	}

	@ViewBuilder private func viewFor(_ multipleValues: MultipleValues) -> some View {
		if let values = multipleValues.value {
			viewFor(values, heading: multipleValues.label)
		}
	}

	@ViewBuilder private func viewFor(_ multipleGroupedValues: MultipleGroupedValues) -> some View {
		if let values = multipleGroupedValues.value {
			let elements = values.flatMap({ $0 })
			viewFor(elements, heading: multipleGroupedValues.label)
		}
	}

	@ViewBuilder private func viewFor(_ referenceLink: ReferenceLink) -> some View {
		if resolvedReferences[referenceLink.reference] == true {
			// Reference Link to details page
			Button {
				self.referenceTapped?(referenceLink.reference)
			} label: {
				viewFor(referenceLink.label, heading: nil, showChevron: true)
			}
			.contentShape(Rectangle())
			.accessibilityIdentifier(referenceLink.label)
		} else {
			viewFor(
				SingleValue(
					id: referenceLink.id,
					label: referenceLink.label,
					type: .singleValue,
					value: DisplayValue(code: nil, display: referenceLink.reference, system: nil)
				)
			)
		}
	}

	@ViewBuilder private func viewFor(_ referenceValue: ReferenceValue) -> some View {
		let value = referenceValue.display ?? referenceValue.reference
		if let reference = referenceValue.reference,
		   resolvedReferences[reference] == true {
			Button {
				self.referenceTapped?(reference)
			} label: {
				viewFor(value, heading: referenceValue.label, showChevron: true)
			}
			.contentShape(Rectangle())
			.accessibilityIdentifier("\(referenceValue.label), \(value ?? "")")
		} else {
			viewFor(
				SingleValue(
					id: referenceValue.id,
					label: referenceValue.label,
					type: .singleValue,
					value: DisplayValue(code: nil, display: value, system: nil)
				)
			)
		}
	}

	@ViewBuilder private func viewFor(_ downloadBinary: DownloadBinary) -> some View {
		HealthDataDownloadView(
			viewModel: HealthDataDownloadViewModel(
				healthcareOrganization: healthcareOrganization,
				downloadBinary: downloadBinary
			)
		)
	}

	@ViewBuilder private func viewFor(_ downloadLink: DownloadLink) -> some View {
		HealthDataDownloadView(
			viewModel: HealthDataDownloadViewModel(
				healthcareOrganization: healthcareOrganization,
				downloadLink: downloadLink
			)
		)
	}

	/// Show a row of data (heading and value)
	@ViewBuilder private func viewFor(_ value: String?, heading: String?, showChevron: Bool = false) -> some View {
		HStack(alignment: .center, spacing: 0) {
			VStack(alignment: .leading, spacing: Layout.labelValueSpacing) {
				if let heading {
					// Headings inside the tappable reference row must not be
					// selectable; UITextView selection gestures conflict with
					// the parent Button's tap.
					viewFor(heading, accessibilityIdentifier: heading, selectable: false)
				}
				let text = Sanitizer.strip(value) ?? unknown
				Text(text)
					.typography(.bodyMedium)
					.foregroundStyle(theme.labels.primary)
					.fixedSize(horizontal: false, vertical: true)
					.accessibilityIdentifier(text)
			}
			Spacer()
			if showChevron {
				Image(systemName: "chevron.right")
					.foregroundStyle(theme.symbols.primary)
					.frame(width: Layout.chevronSize, height: Layout.chevronSize, alignment: .center)
					.accessibilityHidden(true)
			}
		}
	}

	/// A Selectable Text View
	@ViewBuilder private func selectableTextView(_ value: String) -> some View {
		SelectableTextView(
			text: value,
			textColor: theme.labels.primary,
			font: UIFont(name: RijksoverheidFont.regular.fontName, size: Font.TextStyle.body.pointSize)
		)
	}

	/// Show a row of data (heading + ValueDisplay array)
	@ViewBuilder private func viewFor(_ values: [DisplayValue], heading: String?) -> some View {
		VStack(alignment: .leading, spacing: Layout.labelValueSpacing) {
			if let heading {
				viewFor(heading, accessibilityIdentifier: heading)
			}
			viewFor(values)
		}
	}

	/// The view for an array of value displays
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
	@ViewBuilder private func displayCodingLabel(_ text: String) -> some View {
		HStack(alignment: .center, content: {
			Label {
				Text(text)
					.typography(.bodyMedium)
					.backport.underline(pattern: .dot)
			} icon: {
				Image(systemName: "questionmark.circle")
					.resizable()
					.frame(width: Layout.questionMarkSize, height: Layout.questionMarkSize)
			}
			.labelStyle(TrailingIconLabelStyle())
			Spacer()
		})
		.fixedSize(horizontal: false, vertical: true)
		.foregroundStyle(theme.categories.rijkslint)
	}

	/// The view for a heading row
	@ViewBuilder private func viewFor(_ heading: String, accessibilityIdentifier: String, selectable: Bool = true) -> some View {
		if selectable {
			SelectableTextView(
				text: heading,
				textColor: theme.labels.secondary,
				font: UIFont(name: RijksoverheidFont.regular.fontName, size: Font.TextStyle.callout.pointSize)
			)
			.accessibilityIdentifier(accessibilityIdentifier)
			.accessibilityAddTraits(.isHeader)
		} else {
			Text(heading)
				.typography(.bodySmall)
				.foregroundStyle(theme.labels.secondary)
				.fixedSize(horizontal: false, vertical: true)
				.accessibilityIdentifier(accessibilityIdentifier)
				.accessibilityAddTraits(.isHeader)
		}
	}
}
// swiftlint:enable type_body_length

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthUISchemaView(
			schema: PreviewContent.uiSchema,
			healthcareOrganization: PreviewContent.healthcareOrganization,
			resolvedReferences: ["reference": true],
			resolvedCodes: ["code": true]
		)
	}
}
