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

class ZibDetailsViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: ZibDetailViewState
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	/// - Parameter title: the title for the page
	/// - Parameter schema: the UISchema to display
	init(
		coordinator: (any Coordinator)? = nil,
		title: String,
		schema: UISchema
	) {
		self.coordinator = coordinator
		self.state = ZibDetailViewState(title: title, schema: schema)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: ZibDetailsViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
		}
	}
}

struct ZibDetailsView: View {
	
	/// The View Model
	@StateObject var viewModel: ZibDetailsViewModel
	
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
				
				UISchemaDetailsView(schema: viewModel.state.schema)
				
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
		ZibDetailsView(
			viewModel:
				ZibDetailsViewModel(
					coordinator: nil,
					title: "Alle medicijngegevens",
					schema: UISchema(
						children: [
							UISchemaGroup(
								children: [
									Value(
										display: ChildDisplay.string("Value"),
										label: "field.label",
										summary: true,
										type: "Field Type",
										reference: nil
									),
									Value(
										display: ChildDisplay.string("Value2"),
										label: "field.label2",
										summary: true,
										type: "Field Type",
										reference: nil
									)
								],
								label: "Section Header"),
							
							UISchemaGroup(
								children: [
									Value(
										display: ChildDisplay.unionArray([DisplayElement.stringArray(["one", "two"])]),
										label: "field.label3",
										summary: true,
										type: "Field Type",
										reference: nil
									),
									Value(
										display: nil,
										label: "field.label4",
										summary: true,
										type: "Field Type",
										reference: nil
									)
								],
								label: "Section Header 2")
							
						],
						label: "UI Schema"
					)
				)
		)
	}
}
