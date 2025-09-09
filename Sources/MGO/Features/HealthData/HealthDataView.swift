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

	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare organization
	var healthcareOrganization: MgoOrganization

	/// The reference resolver
	weak private var referenceResolver: ReferenceResolverProtocol?
	
	/// The store for references
	var referenceStore = [String: ReferenceStoreEntry?]()
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case closeSheet
		case reference(String)
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
			.flatMap { $0.children }
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
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthDataViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
			
			case let .reference(reference):
				referenceTapped(reference)
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
					resolvedReferences: viewModel.resolvedReferences
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
					viewModel.reduce(.closeSheet)
				}
		})
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
