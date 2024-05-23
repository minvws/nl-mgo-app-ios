/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

enum MedicationListViewState: Equatable {
	
	case loading
	case failure
	case success([MedicationStatement])

	static func == (lhs: MedicationListViewState, rhs: MedicationListViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
				
			case (.failure, .failure):
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

class MedicationListViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: MedicationListViewState
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare provider to display
	private var healthcareProvider: HealthcareProvider
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case onAppear
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil, healthcareProvider: HealthcareProvider) {
		
		self.coordinator = coordinator
		self.healthcareProvider = healthcareProvider
		self.state = .loading
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: MedicationListViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .onAppear:
				SwiftUI.Task {
					 await loadMedication()
				}
		}
	}
	
	@MainActor
	/// Load the medication for the healthcare provider
	func loadMedication() async {
	
		guard let repository: MedicationStatementRepository = FHIRClient() else {
			state = .failure
			return
		}
		
		do {
			let statements = try await repository.list()
			guard statements.isNotEmpty else {
				state = .failure
				return
			}
			state = .success(statements)
		} catch {
			logError("Client read error: \(String(describing: error))")
			state = .failure
		}
	}
}

struct MedicationListView: View {
	
	/// The View Model
	@StateObject var viewModel: MedicationListViewModel
	
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
					
				Text("medication_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					
				Text("medication_body")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentTertiary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.padding(.bottom, ViewTraits.General.spacing)
				
				switch viewModel.state {
					case .loading:
						Spacer()
						MedicationLoadingView()
						Spacer()
					
					case .failure:
						ErrorView(viewModel: ErrorViewModel {
//							viewModel.reduce(.retry)
						})
					
					case .success(let medicationStatements):
						ForEach(medicationStatements, id: \.id) { statement in
							MedicationDetailView(statement: statement)
						}
						Spacer()
				}
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
		MedicationListView(
			viewModel: MedicationListViewModel(
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
