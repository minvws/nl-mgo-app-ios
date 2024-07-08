/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

enum LabResultsListViewState: Equatable {
	
	case loading
	case failure
	case empty
	case success(items: [MgoLaboratoryTestResult], startOpen: Bool)
	
	static func == (lhs: LabResultsListViewState, rhs: LabResultsListViewState) -> Bool {
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

class LabResultsListViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: LabResultsListViewState
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare organization to display
	@Published var healthcareOrganization: HealthcareOrganization
	
	/// The repository for Concerns
	private var laboratoryTestResultRepository: LaboratoryTestResultRepository!
	
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
		healthcareOrganization: HealthcareOrganization,
		repository: LaboratoryTestResultRepository? = FHIRClient(),
		startOpen: Bool = false
	) {

		self.coordinator = coordinator
		self.healthcareOrganization = healthcareOrganization
		self.startOpen = startOpen
		
		if let unwrapped = repository {
			self.laboratoryTestResultRepository = unwrapped
			self.state = .loading
		} else {
			self.state = .failure
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: LabResultsListViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .onAppear:
				_Concurrency.Task {
					await loadResults()
				}
		}
	}
	
	@MainActor
	/// Load the laboratory test results for the healthcare organization
	func loadResults() async {
		
		guard let resourceEndpoint = healthcareOrganization.getResourceEndpoint(identifier: DVP.ServiceId.CommonClinicalDataset) else {
			state = .empty
			return
		}
		
		do {
			let results = try await laboratoryTestResultRepository.fetchResults(dvaTarget: resourceEndpoint)
			if results.isEmpty {
				state = .empty
			} else {
				state = .success(items: results, startOpen: startOpen)
			}
		} catch {
			logError("Client read error: \(String(describing: error))")
			state = .failure
		}
	}
}

struct LabResultsListView: View {

	/// The View Model
	@StateObject var viewModel: LabResultsListViewModel
	
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
				
				Text("lab_results.heading")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Text(
					String(
						format: String(localized: "lab_results.subheading"),
						arguments: ["\(viewModel.healthcareOrganization.display_name)"]
					)
				)
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
				
					case let .success(results, startOpen):
						ForEach(results, id: \.self) { result in
							LabResultsDetailView(result: result, startOpen: startOpen && result == results.first)
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
//
#Preview {
	NavigationStackBackport.NavigationStack {
		LabResultsListView(
			viewModel: LabResultsListViewModel(
				coordinator: nil,
				healthcareOrganization: PreviewContent.healthcareOrganization
			)
		)
	}
}
