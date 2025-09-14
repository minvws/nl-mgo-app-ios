/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct ZibDetailViewState {
	
	var schema: HealthUISchema
	var backButton: String?
}

typealias ReferenceStoreEntry = (resource: MgoResource, isReferenceValue: Bool, schema: HealthUISchema)

class HealthDataViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: ZibDetailViewState
	
	/// An array of resolved references
	@Published var resolvedReferences: [String: Bool] = [:]
	
	/// An array of resolved codes
	@Published var resolvedCodes: [String: Bool] = [:]
	
	/// The selected patient friendly term
	@Published var selectedPatientFriendlyTerm: PatientFriendlyTerm?

	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare organization
	var healthcareOrganization: MgoOrganization

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
		case closeSheet
		case closeTermSheet
		case reference(String)
		case term(DisplayCoding)
	}
	
	/// Create a Healthcare Data View Model
	/// - Parameter coordinator: the app coordinator
	/// - Parameter schema: the HealthUISchema to display
	/// - Parameter backButtonTitle: the title for the back button
	/// - Parameter healthcareOrganization: the healthcare organization
	/// - Parameter referenceResolver: the handler to resolve references
	@MainActor init(
		coordinator: (any Coordinator)? = nil,
		schema: HealthUISchema,
		backButtonTitle: String?,
		healthcareOrganization: MgoOrganization,
		referenceResolver: ReferenceResolverProtocol = ReferenceResolver()
	) {
		self.coordinator = coordinator
		self.state = ZibDetailViewState(schema: schema, backButton: backButtonTitle)
		self.healthcareOrganization = healthcareOrganization
		self.referenceResolver = referenceResolver
		
		prepareReferenceValues()
		prepareReferenceLink()
		prepareTerms()
	}
	
	@MainActor private func prepareReferenceValues() {
	
		filterReferences(.referenceValue).forEach { reference in
			
			if Container.shared.featureFlagManager().isDemo {
				resolvedReferences[reference] = false
			} else {
				storeReference(reference, isReferenceValue: true)
			}
		}
	}
	
	private func prepareReferenceLink() {
	
		filterReferences(.referenceLink).forEach { reference in
			storeReference(reference, isReferenceValue: false)
		}
	}
	
	private func filterReferences(_ type: UIElementType) -> Set<String> {
		
		return Set<String>(state.schema.children
			.flatMap(\.children)
			.filter { $0.type == type }
			.compactMap { $0.reference }
		)
	}
	
	private func storeReference(_ reference: String, isReferenceValue: Bool) {
		
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
	private func prepareTerms() {
		
		// The list of SingleValueDisplays
		var values: [SingleValueDisplay] = [SingleValueDisplay]()
		
		// Append the list with MultipleValues
		values.append(contentsOf: state.schema.children
			.flatMap { $0.uiElements }
			.compactMap { $0 as? MultipleValues }
			.compactMap { $0.display }
			.flatMap { $0 })
		
		// Append the list with MultipleGroupedValues
		values.append(contentsOf: state.schema.children
			.flatMap { $0.uiElements }
			.compactMap { $0 as? MultipleGroupedValues }
			.compactMap { $0.display }
			.flatMap { $0 }
			.flatMap { $0 }
		)
		
		// Append the list with SingleValues
		values.append(contentsOf: state.schema.children
			.flatMap { $0.uiElements }
			.compactMap { $0 as? SingleValue }
			.compactMap { $0.display }
		)
		
		// Check the values and see if there is a patient friendly term available
		values.forEach { singleDisplayValue in
			if case let .displayCoding(displayCoding) = singleDisplayValue {
				
				guard displayCoding.system == PatientFriendlyTermsRepository.snomedCTSystem,
					  let code = displayCoding.code else {
					return
				}
				if let term = patientFriendyTermsRepository.find(code) {
					patientFriendlyTermsStore[code] = term
					resolvedCodes[code] = true
				}
			}
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthDataViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
			
			case .closeTermSheet:
				selectedPatientFriendlyTerm = nil
			
			case let .reference(reference):
				referenceTapped(reference)
			
			case let .term(displayCoding):
				termTapped(displayCoding)
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
	/// - Parameter displayCoding: the display coding object tapped on
	@MainActor private func termTapped(_ displayCoding: DisplayCoding) {
		
		guard let code = displayCoding.code, let foundTerm = patientFriendlyTermsStore[code] else {
			logInfo("HealthDataView - no term found for:", displayCoding)
			return
		}
		selectedPatientFriendlyTerm = foundTerm
	}
}

struct HealthDataView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthDataViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
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
		
		ScrollView {
			
			VStack(spacing: ViewTraits.General.padding) {
				
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
				Spacer()
			}
			.padding(.top, ViewTraits.Navigation.padding)
			.padding(.horizontal, ViewTraits.General.padding)
		}
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.navigationBarBackButtonHidden()
		.when(viewModel.state.backButton != nil) { view in
			view
				.navigationBarItems(leading: BackButton(LocalizedStringKey(stringLiteral: viewModel.state.backButton!)) {
					viewModel.reduce(.backButtonPressed)
				})
		}
		.navigationBarHidden(false)
		.navigationTitle(viewModel.state.schema.label)
		.when(isPresentedAsSheet, transform: { view in
			view
				.withToolbarCloseButton {
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
		
		NavigationStackBackport.NavigationStack {
			PatientFriendlyTermView(
				viewModel: PatientFriendlyTermViewModel(
					onClose: {
						viewModel.reduce(.closeTermSheet)
					},
					term: viewModel.selectedPatientFriendlyTerm!
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

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthDataView(
			viewModel:
				HealthDataViewModel(
					coordinator: nil,
					schema: PreviewContent.uiSchema,
					backButtonTitle: String(localized: "hc_medication.heading"),
					healthcareOrganization: PreviewContent.healthcareOrganization
				)
		)
	}
}
