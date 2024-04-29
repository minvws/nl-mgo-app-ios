/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class PatientViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// The FHIR Client
	private let client: FHIRClient
	
	//	private let serverURL = URL(string: "http://localhost:4004/hapi-fhir-jpaserver/fhir/")! // R4
	//	private let serverURL = URL(string: "http://localhost:4003/hapi-fhir-jpaserver/fhir/") // STU3
	//	private let serverURL = URL(string: "http://localhost:4002/hapi-fhir-jpaserver/fhir/")! // DSTU2
	private let serverURL = URL(string: "https://hapi.fhir.org/baseDstu3") // Remote STU3
	
	@Published var showResetButton: Bool = false
	@Published var showResetDialog: Bool = false
	@Published var state: State
	@Published var patientID: String = "smart-1032702"
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case search(String)
	}
	
	// All possible states for this ViewModel
	enum State {
		case input
		case loading
		case error(String)
		case patient(Patient)
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any AppCoordinatorProtocol)? = nil) {
		self.coordinator = coordinator
		
		let release = Configuration().getRelease()
		showResetButton = release != Release.production // Show only in Dev, Acc & Test
		
		guard let url = serverURL else {
			fatalError("Invalid server url: \(String(describing: serverURL))")
		}
		
		state = .input
		client = FHIRClient(baseURL: url)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor
	func reduce(_ action: PatientViewModel.Action) {
		
		switch action {
			case .search:
				SwiftUI.Task {
					self.state = await readPatientAsync()
				}
		}
	}
	
	/// Fetch the patient async
	/// - Returns: the new state
	private func readPatientAsync() async -> State {
		
		guard !patientID.isEmpty else {
			return .error("Vul een patient ID in!")
		}
		
		do {
			let patient = try await Patient.read(patientID, client: client, options: .lenient)
			if let pat = patient as? Patient {
				return .patient(pat)
			} else {
				return .error("Can't convert resource to patient")
			}
		} catch {
			logError("Client read error: \(String(describing: error))")
			return .error(error.localizedDescription + "\n" + String(describing: error))
		}
	}
}

struct PatientView: View {
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// The Theme
	@Environment(\.theme) var theme
	
	@StateObject var viewModel: PatientViewModel
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
	}
	
	var body: some View {
		ZStack {
			theme.backgroundPrimary
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			VStack(alignment: .leading) {
				
				Text("Proof of Concept **FHIR Client**\nDeze client haalt de patient gegevens op van [hapi.fhir.org](https://hapi.fhir.org/home?serverId=home_21)")
					.rijksoverheidStyle(font: .regular, style: .body)
					.padding(16)
				
				HStack {
				
					Text(verbatim: "Patient ID")
					
					TextField("Patient ID", text: $viewModel.patientID)
						.border(theme.contentPrimary)
						.onSubmit {
							viewModel.reduce(.search(viewModel.patientID))
						}
				}
				.rijksoverheidStyle(font: .regular, style: .body)
				.padding(16)
				
				switch viewModel.state {
					case .input:
						EmptyView()
					case .loading:
						Text("launch_loading")
						
					case .error(let error):
						HStack {
							Text(error)
						}
						.frame(maxWidth: .infinity)
						.border(.red, width: 2)
						.padding(16)
						
					case .patient(let patient):
						HStack {
							VStack(alignment: .leading) {
								
								if let patientID = patient.id?.value?.string {
									Text(verbatim: "Patient ID: ") + Text(patientID)
								}
								if let humanName = patient.humanName {
									Text(verbatim: "Naam: ") + Text(humanName)
								}
								
								if let humanBirthDateMedium = patient.humanBirthDateMedium {
									Text(verbatim: "Geboortedatum: ") + Text(humanBirthDateMedium)
								}
								if let email = patient.email {
									Text(verbatim: "Email: ") + Text(email)
								}
							}
							Spacer()
						}
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundStyle(theme.contentPrimary)
						.padding(16)
						.background(theme.backgroundTertiary)
				}
			}
			.padding(.top, ViewTraits.Navigation.padding)
		}
	}
}

#Preview {
	PatientView(viewModel: PatientViewModel())
}
