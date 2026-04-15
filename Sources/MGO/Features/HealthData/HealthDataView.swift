/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct HealthDataViewState {
	
	var schema: HealthUISchema
	var backButton: String?
	var showExportAlert: Bool
}

typealias ReferenceStoreEntry = (
	resource: MgoResource,
	isReferenceValue: Bool,
	schema: HealthUISchema
)

class HealthDataViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: HealthDataViewState
	
	/// An array of resolved references
	@Published var resolvedReferences: [String: Bool] = [:]
	
	/// An array of resolved codes
	@Published var resolvedCodes: [String: Bool] = [:]
	
	/// The selected patient friendly term
	@Published var selectedPatientFriendlyTerm: PatientFriendlyTerm?

	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare organization
	var healthcareOrganization: OrganizationSearch.Organization

	/// The reference resolver
	weak private var referenceResolver: ReferenceResolverProtocol?
	
	/// The store for references
	var referenceStore = [String: ReferenceStoreEntry?]()
	
	/// The store to hold all the patient friendly terms for this resource
	var patientFriendlyTermsStore = [String: PatientFriendlyTerm]()
	
	/// Dependency Injectable Patient Friendly Terms Repository
	@Injected(\.patientFriendyTermsRepository) private var patientFriendyTermsRepository
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case cancelExportAlert
		case closeSheet
		case closeTermSheet
		case exportHealthData
		case reference(String)
		case showExportAlert
		case term(DisplayValue)
	}
	
	/// Create a Healthcare Data View Model
	/// - Parameter coordinator: the app coordinator
	/// - Parameter schema: the HealthUISchema to display
	/// - Parameter backButtonTitle: the title for the back button
	/// - Parameter healthcareOrganization: the healthcare organization
	/// - Parameter referenceResolver: the handler to resolve references
	@MainActor init(
		coordinator: (any Coordinator)? = nil,
		config: HealthDataViewConfig,
		schema: HealthUISchema,
		healthcareOrganization: OrganizationSearch.Organization,
		referenceResolver: ReferenceResolverProtocol = ReferenceResolver()
	) {
		self.coordinator = coordinator
		self.state = HealthDataViewState(
			schema: schema,
			backButton: config.backButtonTitle,
			showExportAlert: false
		)
		self.healthcareOrganization = healthcareOrganization
		self.referenceResolver = referenceResolver
		
		prepareReferenceValues()
		prepareReferenceLink()
		prepareTerms()
	}
	
	@MainActor private func prepareReferenceValues() {
	
		filterReferences(.referenceValue).forEach { reference in
			storeReference(reference, isReferenceValue: true)
		}
	}
	
	@MainActor private func prepareReferenceLink() {
	
		filterReferences(.referenceLink).forEach { reference in
			storeReference(reference, isReferenceValue: false)
		}
	}
	
	@MainActor private func filterReferences(_ type: UIElementType) -> Set<String> {
		
		return Set<String>(state.schema.children
			.flatMap(\.children)
			.filter { $0.type == type }
			.compactMap { $0.reference }
		)
	}
	
	@MainActor private func storeReference(_ reference: String, isReferenceValue: Bool) {
		
		let result = referenceResolver?.resolve(
			reference: reference,
			healthcareOrganization: healthcareOrganization
		)
		if let result {
			referenceStore[reference] = ReferenceStoreEntry(
				resource: result.0,
				isReferenceValue: isReferenceValue,
				schema: result.1
			)
		}
		resolvedReferences[reference] = result != nil
	}
	
	/// Prepare the patient friendly terms
	@MainActor private func prepareTerms() {
		
		// The list of DisplayValue
		var values: [DisplayValue] = [DisplayValue]()
		
		// Append the list with MultipleValues
		values.append(contentsOf: state.schema.children
			.flatMap { $0.uiElements }
			.compactMap { $0 as? MultipleValues }
			.compactMap { $0.value }
			.flatMap { $0 })
		
		// Append the list with MultipleGroupedValues
		values.append(contentsOf: state.schema.children
			.flatMap { $0.uiElements }
			.compactMap { $0 as? MultipleGroupedValues }
			.compactMap { $0.value }
			.flatMap { $0 }
			.flatMap { $0 }
		)
		
		// Append the list with SingleValues
		values.append(contentsOf: state.schema.children
			.flatMap { $0.uiElements }
			.compactMap { $0 as? SingleValue }
			.compactMap { $0.value }
		)
		
		// Check the values and see if there is a patient friendly term available
		values.forEach { displayValue in
			
			guard displayValue.system == PatientFriendlyTermsRepository.snomedCTSystem,
				  let code = displayValue.code else {
				return
			}
			if let term = patientFriendyTermsRepository.find(code) {
				patientFriendlyTermsStore[code] = term
				resolvedCodes[code] = true
			}
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthDataViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
				
			case .cancelExportAlert:
				state.showExportAlert = false
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
			
			case .closeTermSheet:
				selectedPatientFriendlyTerm = nil
			
			case .exportHealthData:
				let data = HealthDataMapper().map(
					state.schema
				)
				
				coordinator?.handle(
					Coordination.Action(
						identifier: Coordination.Action.exportHealthData.identifier,
						params: [
							"healthData": data
						]
					)
				)
				
			case let .reference(reference):
				referenceTapped(reference)
			
			case .showExportAlert:
				state.showExportAlert = true
				
			case let .term(displayValue):
				termTapped(displayValue)
		}
	}
	
	/// Handle the reference tap
	/// - Parameter reference: the reference id tapped on
	@MainActor private func referenceTapped(_ reference: String) {
		
		guard let resolved = referenceStore[reference] else { return }
		
		if let (resource, isReferenceValue, refSchema) = resolved {
			
			self.coordinator?.handle(
				Coordination.Action(
					identifier: Coordination.Action.showHealthData.identifier,
					params: [
						"healthcareOrganization": healthcareOrganization,
						"backButtonTitle": "common.previous",
						"resource": resource,
						"uiSchema": refSchema,
						"inSheet": isReferenceValue
					]
				)
			)
		}
	}
	
	/// Handle the patient friendly term tap
	/// - Parameter displayValue: the display coding object tapped on
	@MainActor private func termTapped(_ displayValue: DisplayValue) {
		
		guard let code = displayValue.code,
			  let foundTerm = patientFriendlyTermsStore[code] else {
			logInfo("HealthDataView - no term found for:", displayValue)
			return
		}
		selectedPatientFriendlyTerm = foundTerm
	}
}

struct HealthDataView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthDataViewModel
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
	}
	
	var body: some View {
		
		HealthUISchemaView(
			schema: viewModel.state.schema,
			healthcareOrganization: viewModel.healthcareOrganization,
			referenceTapped: { reference in
				if let reference {
					viewModel.reduce(.reference(reference))
				}
			},
			resolvedReferences: viewModel.resolvedReferences,
			codeTapped: { displayCoding in
				if let displayCoding {
					viewModel.reduce(.term(displayCoding))
				}
			},
			resolvedCodes: viewModel.resolvedCodes
		)
		.toolbar { pdfExportToolbarContent }
		.alert(
			String(localized: "export_pdf.dialog.heading"),
			isPresented: $viewModel.state.showExportAlert
		) {
			Button("export_pdf.dialog.create_document") { viewModel.reduce(.exportHealthData) }
			Button("common.cancel", role: ButtonRole.cancel) { viewModel.reduce(.cancelExportAlert) }
				.keyboardShortcut(.cancelAction)
		} message: {
			Text("export_pdf.dialog.subheading")
		}
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.navigationBarBackButtonHidden()
		.when(viewModel.state.backButton != nil) { view in
			view
				.navigationBarItems(leading: BackButton {
					viewModel.reduce(.backButtonPressed)
				})
		}
		.navigationBarHidden(false)
		.when(isPresentedAsSheet, transform: { view in
			view
				.withToolbarCloseButton(osVersionChecker.available(version: .iOS(.v26))) {
					// This closes the view when shown in a sheet aka a reference
					viewModel.reduce(.closeSheet)
				}
		})
		.inspectableSheet(
			isPresented: $viewModel.selectedPatientFriendlyTerm.presence(),
			onDismiss: {
				// Called when the sheet is closed by dragging, used for the term sheet
				viewModel.reduce(.closeTermSheet)
			},
			content: {
				sheetContent()
			}
		)
	}
	
	/// The content for the sheet
	/// - Returns: sheet content
	@ViewBuilder private func sheetContent() -> some View {
		
		if let term = viewModel.selectedPatientFriendlyTerm {
			
			NavigationStackBackport.NavigationStack {
				PatientFriendlyTermView(
					viewModel: PatientFriendlyTermViewModel(
						onClose: {
							viewModel.reduce(.closeTermSheet)
						},
						term: term
					)
				)
				.isPresentedAsSheet(!isIOS15)
				.navigationBarBackButtonHidden(true)
				.navigationBarTitleDisplayMode(.inline)
				.backport.presentationContentInteraction(.scrolls)
				.backport.presentationDragIndicator(UIDevice.current.userInterfaceIdiom == .pad ? Visibility.hidden : Visibility.visible) // Hide on iPad
			}
		}
	}
	
	/// The toolbar content (export to pdf)
	private var pdfExportToolbarContent: some ToolbarContent {
		PDFExportToolbarContent {
			viewModel.reduce(.showExportAlert)
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthDataView(
			viewModel:
				HealthDataViewModel(
					coordinator: nil,
					config: HealthDataViewConfig(
						backButtonTitle: String(localized: "hc_medication.heading"),
						inSheet: false
					),
					schema: PreviewContent.uiSchema,
					healthcareOrganization: PreviewContent.healthcareOrganization
				)
		)
	}
}
