/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import FHIRClient

class PatientViewModel: ObservableObject {
	
	//	let serverURL = URL(string: "http://localhost:4004/hapi-fhir-jpaserver/fhir/")! // R4
//	let serverURL = URL(string: "http://localhost:4003/hapi-fhir-jpaserver/fhir/")! // STU3
	//	let serverURL = URL(string: "http://localhost:4002/hapi-fhir-jpaserver/fhir/")! // DSTU2
	let serverURL = URL(string: "https://hapi.fhir.org/baseDstu3")! // Remote STU3
	
	let client: Client
	
	// All possible states for this ViewModel
	enum State {
		case input
		case loading
		case error(String)
		case patient(Patient)
	}
	
	@Published var state: State
	
//	@Published var patientID: String = "smart-1032702" { // STU3
	@Published var patientID: String = "2810051" { // Remote STU3
		didSet {
			self.state = .input
		}
	}
	
	init() {
		state = .input
		
		client = Client(
			baseURL: serverURL,
			settings: [
				"client_id": "mgo",
				"redirect": "mgo://callback"
			]
		)
		client.authProperties.embedded = true
		client.authProperties.granularity = .tokenOnly
	}
	
	@MainActor
	func start() {
		
		//		client.authorize { _, error in
		//			DispatchQueue.main.async {
		//				guard error == nil else {
		//					logError("Client authorize error: \(String(describing: error))")
		//					self.errorLog = error.debugDescription
		//					self.isLoading = false
		//					return
		//				}
		//			}
		//			self.readPatient()
		
		SwiftUI.Task {
			self.state = await readPatientAsync()
		}
		//		}
	}
	
	private func readPatient() {
		Patient.read(self.patientID, server: self.client.server, options: .lenient) { resource, error in
			DispatchQueue.main.async {
				
				guard error == nil else {
					logError("Client read error: \(String(describing: error))")
					self.state = .error(error.debugDescription)
					return
				}
				
				if let json = try? resource?.asJSON() {
					
					let patient = Patient()
					var context = FHIRInstantiationContext(strict: true)
					patient.populate(from: json, context: &context)
					guard context.errors.isEmpty else {
						logError("Validation Error: \(context.errors)")
						self.state = .error("Validation errors")
						return
					}
					self.state = .patient(patient)
				}
				
				//				if let json = try? resource?.asJSON(),
				//				   let patient = try? Patient(json: json) {
				//					self.state = .patient(patient)
				//				}
			}
		}
	}
	
	/// Fetch the patient
	/// - Returns: the new state
	private func readPatientAsync() async -> State {
		
		do {
			let resource = try await Patient.read(patientID, server: client.server, options: .lenient)
			if let json = try? resource.asJSON(),
			   let patient = try? Patient(json: json) {
				return .patient(patient)
			} else {
				return .error("Resource not found.")
			}
		} catch {
			logError("Client read error: \(String(describing: error))")
			return .error(error.localizedDescription)
		}
	}
}

struct PatientView: View {
	
	@StateObject var viewModel: PatientViewModel
	
	var body: some View {
		ZStack {
			Color.Styleguide.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			VStack(alignment: .leading) {
				
				Text("Proof of Concept **FHIR Client**\nDeze client haalt de patient gegevens op van [hapi.fhir.org](https://hapi.fhir.org/home?serverId=home_21)")
					.rijksoverheidStyle(font: .regular, style: .body)
					.padding(16)
				
				HStack {
				
					Text(verbatim: "Patient ID")
					
					TextField("Patient ID", text: $viewModel.patientID)
						.border(Color.Styleguide.black)
						.onSubmit {
							viewModel.start()
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
								
								if let patientID = patient.id {
									Text(verbatim: "Patient ID: ") + Text(patientID.string)
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
						.padding(16)
						.background(Color.Styleguide.Grey.grey2)
				}
			}
		}
		.navigationBarBackButtonHidden()
	}
}

#Preview {
	PatientView(viewModel: PatientViewModel())
}
