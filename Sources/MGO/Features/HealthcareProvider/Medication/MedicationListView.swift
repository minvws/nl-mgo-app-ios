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
	case failure(Error)
	case success([MedicationStatement])

	static func == (lhs: MedicationListViewState, rhs: MedicationListViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
				
			case let(.failure(lhsError), .failure(rhsError)):
				return lhsError.localizedDescription == rhsError.localizedDescription
			
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
					self.state = await loadMedication()
				}
		}
	}
//URL: https://dva.test.mgo.irealisatie.nl/fhir/MedicationStatement?_format=json&category=urn%3Aoid%3A2.16.840.1.113883.2.4.3.11.60.20.77.5.3%7C6&_include=MedicationStatement%3Amedication
	
	private let serverURL = URL(string: "https://dva.test.mgo.irealisatie.nl/fhir")
	
	@MainActor
	func loadMedication() async -> MedicationListViewState {
	
		let client = FHIRClient(baseURL: serverURL!)
		
		do {
			let bundle = try await MedicationStatement.read("?_format=json&category=urn%3Aoid%3A2.16.840.1.113883.2.4.3.11.60.20.77.5.3%7C6&_include=MedicationStatement%3Amedication", client: client) as? ModelsSTU3.Bundle

			
			let observations = bundle?.entry?.compactMap {
				$0.resource?.get(if: ModelsSTU3.MedicationStatement.self)
			}
			
			if let result = observations {
				return .success(result)
			}
			return .loading
		} catch {
			logError("Client read error: \(String(describing: error))")
			return .failure(error)
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
						MedicationListLoadingView()
						Spacer()
					
					case .failure(let error):
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
