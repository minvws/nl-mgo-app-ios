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
	case success(items: [MgoConcern], startOpen: Bool)
	
	static func == (lhs: ProblemsListViewState, rhs: ProblemsListViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
				
			case (.failure, .failure):
				return true
				
			case (.empty, .empty):
				return true
				
			case let(.success(lhsList, lhsOpen), .success(rhsList, rhsOpen)):
		
				guard lhsList.count == rhsList.count else { return false }
				guard lhsOpen == rhsOpen else { return false }
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
	
	/// The healthcare organization to display
	@Published var healthcareOrganization: MgoOrganization
	
	/// The repository for Concerns
	private var concernRepository: ConcernRepository!
	
	/// Should we start with the first item open?
	private var startOpen: Bool
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case onAppear
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(
		coordinator: (any Coordinator)? = nil,
		healthcareOrganization: MgoOrganization,
		repository: ConcernRepository? = FHIRClient(),
		startOpen: Bool = false
	) {

		self.coordinator = coordinator
		self.healthcareOrganization = healthcareOrganization
		self.startOpen = startOpen
		
		if let unwrapped = repository {
			self.concernRepository = unwrapped
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
				_Concurrency.Task {
					await loadProblems()
				}
		}
	}
	
	@MainActor
	/// Load the medication for the healthcare organization
	func loadProblems() async {
		
		guard let resourceEndpoint = healthcareOrganization.getResourceEndpoint(identifier: DVP.CommonClinicalDataset.serviceID) else {
			state = .empty
			return
		}
		
		do {
			let concerns = try await concernRepository.fetchConcerns(dvaTarget: resourceEndpoint)
			if concerns.isEmpty {
				state = .empty
			} else {
				state = .success(items: concerns, startOpen: startOpen)
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
		}
		enum List {
			static let top: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollView {
			
			VStack(spacing: ViewTraits.General.padding) {
				
				Text("problems.heading")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Text("problems.subheading")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentTertiary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.padding(.bottom, ViewTraits.List.top)
				
				switch viewModel.state {
					case .loading:
			
						Spacer()
						LoadingCardView(
							title: "common.loading",
							showBorder: false
						)
				
					case .empty:
						
						NotificationCardView(
							icon: Image(ImageResource.Woman.womanOnCouch),
							title: "common.no_results_heading",
							message: "common.no_results_subheading"
						)
				
					case .failure:

						NotificationCardView(
							icon: Image(ImageResource.Woman.womanOnCouchExclamation),
							title: "common.failure_heading",
							message: "common.failure_subheading"
						)
				
					case let .success(concerns, startOpen):
						ForEach(concerns, id: \.self) { concern in
							ProblemDetailView(concern: concern, startOpen: startOpen && concern == concerns.first)
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
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		ProblemsListView(
			viewModel: ProblemsListViewModel(
				coordinator: nil,
				healthcareOrganization: PreviewContent.healthcareOrganization
			)
		)
	}
}
