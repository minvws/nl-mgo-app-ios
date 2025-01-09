/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import Zibs

struct ZibDetailViewState {
	
	var title: String
	var schema: UISchema
}

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
	var referenceResolver: ReferenceResolverProtocol
	
	/// The store for references
	var referenceStore = [String: (MgoResource, UISchema)?]()
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case reference(String)
	}
	
	/// Create a Healthcare Data View Model
	/// - Parameter coordinator: the app coordinator
	/// - Parameter title: the title for the page
	/// - Parameter schema: the UISchema to display
	/// - Parameter healthcareOrganization: the healthcare organization
	/// - Parameter referenceResolver: the handler to resolve references
	init(
		coordinator: (any Coordinator)? = nil,
		title: String,
		schema: UISchema,
		healthcareOrganization: MgoOrganization,
		referenceResolver: ReferenceResolverProtocol = ReferenceResolver()
	) {
		self.coordinator = coordinator
		self.state = ZibDetailViewState(title: title, schema: schema)
		self.healthcareOrganization = healthcareOrganization
		self.referenceResolver = referenceResolver
		
		prepareReferences()
	}
	
	private func prepareReferences() {
	
		let referenceStrings = Set<String>(state.schema.children
			.flatMap { $0.children }
			.filter { $0.type == .referenceValue }
			.compactMap { $0.reference }
		)
		referenceStrings.forEach { reference in
			
			if Current.featureFlagManager.isDemo {
				
				resolvedReferences[reference] = false
			} else {
				
				let result = referenceResolver.resolve(reference: reference, healthcareOrganization: healthcareOrganization)
				referenceStore[reference] = result
				resolvedReferences[reference] = result != nil
			}
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthDataViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case let .reference(reference):
				referenceTapped(reference)
		}
	}
	
	/// Handle the reference tap
	/// - Parameter reference: the reference id tapped on
	private func referenceTapped(_ reference: String) {
		
		guard let resolved = referenceStore[reference] else { return }
		
		if let (resource, refSchema) = resolved {
			
			self.coordinator?.handle(Coordination.Action(
				identifier: Coordination.Action.showHealthData.identifier,
				params: [
					"healthcareOrganization": healthcareOrganization,
					"heading": refSchema.label ?? "",
					"resource": resource,
					"uiSchema": refSchema
				])
			)
		}
	}
}

struct HealthDataView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthDataViewModel
	
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
	}
	
	var body: some View {
		
		ScrollViewWithDivider {
			
			VStack(spacing: ViewTraits.General.padding) {
				
				UISchemaView(
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
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationTitle(viewModel.state.title)
		.navigationBarTitleDisplayMode(.inline)
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthDataView(
			viewModel:
				HealthDataViewModel(
					coordinator: nil,
					title: String(localized: "hc_medication.heading_detail"),
					schema:
						UISchema(
							children: [
								// Schema Group 1
								UISchemaGroup(
									children: [
										UIElement(
											display: UIElementDisplay.string("single value"),
											label: "label single value",
											type: .singleValue,
											reference: nil,
											url: nil
										),
										UIElement(
											display: nil,
											label: "label reference",
											type: .referenceValue,
											reference: "reference",
											url: nil
										),
										UIElement(
											display: nil,
											label: "label download link",
											type: .downloadLink,
											reference: nil,
											url: "https://www.apple.com"
										)
									],
									label: "Section Header first group"
								),
								// Schema Group 2
								UISchemaGroup(
									children: [
										// Unknown
										UIElement(
											display: nil,
											label: "label single value nil",
											type: .singleValue,
											reference: nil,
											url: nil
										),
										UIElement(
											display: UIElementDisplay.unionArray([
												DisplayElement.stringArray(["one", "two"]),
												DisplayElement.stringArray(["three", "four"])
											]),
											label: "label multiple group value",
											type: .multipleGroupedValues,
											reference: nil,
											url: nil
										),
										UIElement(
											display: UIElementDisplay.unionArray([DisplayElement.stringArray(["one", "two"])]),
											label: "label multiple value",
											type: .multipleValues,
											reference: nil,
											url: nil
										),
										UIElement(
											display: UIElementDisplay.unionArray([DisplayElement.string("one")]),
											label: "label union value",
											type: .multipleValues,
											reference: nil,
											url: nil
										)
									],
									label: "Section Header second group")
							],
							label: "UI Schema"
						),
					healthcareOrganization: PreviewContent.healthcareOrganization
				)
		)
	}
}
