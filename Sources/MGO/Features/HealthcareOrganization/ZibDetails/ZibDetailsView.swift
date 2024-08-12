/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import JavaScriptCore

enum ZibDetailViewState: Equatable {
	
	case loading
	case failure
	case empty
	case success(schema: UISchema)
	
	static func == (lhs: ZibDetailViewState, rhs: ZibDetailViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
				
			case (.failure, .failure):
				return true
				
			case (.empty, .empty):
				return true
				
			case let(.success(lhsSchema), .success(rhsSchema)):
				return lhsSchema == rhsSchema
				
			default:
				return false
		}
	}
}

class ZibDetailsViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: ZibDetailViewState
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare organization to display
	@Published var healthcareOrganization: MgoOrganization
	
	@Published var title: String
	
	/// The repository for Medication Use
	private var medicationUseRepository: MedicationUseRepository!
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case onAppear
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	/// - Parameter healthcareOrganization: the healthcare organization
	/// - Parameter repository: the repository
	init(
		coordinator: (any Coordinator)? = nil,
		title: String,
		healthcareOrganization: MgoOrganization,
		repository: MedicationUseRepository? = FHIRClient()
	) {
		self.coordinator = coordinator
		self.title = title
		self.healthcareOrganization = healthcareOrganization
		
		if let unwrapped = repository {
			self.medicationUseRepository = unwrapped
			self.state = .loading
		} else {
			self.state = .failure
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: MedicationListViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .onAppear:
				_Concurrency.Task {
					await loadMedication()
				}
		}
	}
	
	@MainActor
	/// Load the medication for the healthcare organization
	func loadMedication() async {
		
		guard let resourceEndpoint = healthcareOrganization.getResourceEndpoint(identifier: DVP.CommonClinicalDataset.serviceID) else {
			state = .empty
			return
		}
		
		do {
			let schema = try await medicationUseRepository.fetchMedicationSchema(dvaTarget: resourceEndpoint)
			if let schema {
				state = .success(schema: schema)
			} else {
				state = .empty
			}
		} catch {
			logError("Client read error: \(String(describing: error))")
			state = .failure
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
	//
	var body: some View {
		
		ScrollView {
			
			VStack(spacing: ViewTraits.General.padding) {

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
					
					case let .success(schema):
					
						UISchemaDetailsView(schema: schema)
				}
				Spacer()
			}
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("zib_details.back") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationTitle(viewModel.title)
		.navigationBarTitleDisplayMode(.automatic)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		ZibDetailsView(
			viewModel: ZibDetailsViewModel(
				coordinator: nil,
				title: "Alle medicijngegevens",
				healthcareOrganization: PreviewContent.healthcareOrganization
			)
		)
	}
}
