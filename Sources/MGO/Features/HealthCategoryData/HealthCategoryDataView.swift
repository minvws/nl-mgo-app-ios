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

class HealthCategoryDataViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: ZibDetailViewState
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare organization
	var healthcareOrganization: MgoOrganization
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	/// - Parameter title: the title for the page
	/// - Parameter schema: the UISchema to display
	/// - Parameter healthcareOrganization: the healthcare organization
	init(
		coordinator: (any Coordinator)? = nil,
		title: String,
		schema: UISchema,
		healthcareOrganization: MgoOrganization
	) {
		self.coordinator = coordinator
		self.state = ZibDetailViewState(title: title, schema: schema)
		self.healthcareOrganization = healthcareOrganization
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthCategoryDataViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
		}
	}
}

struct HealthCategoryDataView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthCategoryDataViewModel
	
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
					healthcareOrganization: viewModel.healthcareOrganization
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
		HealthCategoryDataView(
			viewModel:
				HealthCategoryDataViewModel(
					coordinator: nil,
					title: String(localized: "hc_medication.heading_detail"),
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
										),
										UIEntry(
											display: UIEntryDisplay.unionArray([
												DisplayElement.stringArray(["one", "two"]),
												DisplayElement.stringArray(["three", "four"])
											]),
											label: "label multiple group value",
											summary: true,
											type: .multipleGroupedValues,
											reference: nil,
											url: nil
										),
										UIEntry(
											display: UIEntryDisplay.unionArray([DisplayElement.stringArray(["one", "two"])]),
											label: "label multiple value",
											summary: true,
											type: .multipleValues,
											reference: nil,
											url: nil
										),
										UIEntry(
											display: UIEntryDisplay.unionArray([DisplayElement.string("one")]),
											label: "label union value",
											summary: true,
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
