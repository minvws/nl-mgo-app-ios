/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

enum ProblemsListViewState: Equatable {
	
	case loading
	case failure
	case empty
	case success([Condition])
	
	static func == (lhs: ProblemsListViewState, rhs: ProblemsListViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
				
			case (.failure, .failure):
				return true
				
			case (.empty, .empty):
				return true
				
			case let(.success(lhsList), .success(rhsList)):
				
				guard lhsList.count == rhsList.count else { return false }
				var result = true
				for index in lhsList.indices {
					result = result && lhsList[index] == rhsList[index]
				}
				return result
				
			default:
				return false
		}
	}
}

class ProblemsListViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: ProblemsListViewState
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare provider to display
	private var healthcareProvider: HealthcareProvider
	
	/// The repository for Conditions
	private var conditionRepository: ConditionRepository!
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case onAppear
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(
		coordinator: (any Coordinator)? = nil,
		healthcareProvider: HealthcareProvider,
		repository: ConditionRepository? = FHIRClient()) {

			self.coordinator = coordinator
			self.healthcareProvider = healthcareProvider
			
			if let unwrapped = repository {
				self.conditionRepository = unwrapped
				self.state = .loading
			} else {
				self.state = .failure
			}
		}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: ProblemsListViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .onAppear:
				SwiftUI.Task {
					await loadProblems()
				}
		}
	}
	
	@MainActor
	/// Load the medication for the healthcare provider
	func loadProblems() async {
		
		do {
			let conditions = try await conditionRepository.fetchConditions()
			if conditions.isEmpty {
				state = .empty
			} else {
				state = .success(conditions)
			}
		} catch {
			logError("Client read error: \(String(describing: error))")
			state = .failure
		}
	}
}
//
struct ProblemsListView: View {
	
	/// The View Model
	@StateObject var viewModel: ProblemsListViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 24
		}
		enum List {
			static let spacing: CGFloat = 4
			static let top: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollView {
			
			VStack(spacing: ViewTraits.General.padding) {
				
				Text("problems_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Text("problems_body")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentTertiary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.padding(.bottom, ViewTraits.General.spacing)
				
				switch viewModel.state {
					case .loading:
			
						LoadingCardView(title: "launch_loading")
				
					case .empty:
						
						NotificationCardView(
							icon: Image(ImageResource.Woman.womanOnCouch),
							title: "general_nodata_title",
							message: "general_nodata_body"
						)
				
					case .failure:

						NotificationCardView(
							icon: Image(ImageResource.Woman.womanOnCouchExclamation),
							title: "general_failure_title",
							message: "general_failure_body"
						)
				
					case .success(let conditions):

						ForEach(conditions, id: \.id) { condition in
							ProblemDetailView(condition: condition)
						}
				}
				
				Spacer()
			}
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		ProblemsListView(
			viewModel: ProblemsListViewModel(
				coordinator: nil,
				healthcareProvider: HealthcareProvider(
					display_name: "Tandarts Tandje Erbij",
					identification_type: "type",
					identification_value: "1",
					active: true,
					addresses: [Components.Schemas.Address(
						active: true,
						address: "Boorplatform 5",
						city: "Roermond",
						lines: ["Boorplatform 5"],
						postalcode: "1234AB",
						_type: "postal")
					],
					names: [],
					types: [Components.Schemas.CType(code: "01", display_name: "Tandarts", _type: "")],
					data_services: []
				)
			)
		)
	}
}
