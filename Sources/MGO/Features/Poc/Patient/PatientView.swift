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
	
	let patientID = "smart-1032702"
//	let serverURL = URL(string: "http://localhost:4004/hapi-fhir-jpaserver/fhir/")! // R4
	let serverURL = URL(string: "http://localhost:4003/hapi-fhir-jpaserver/fhir/")! // STU3
//	let serverURL = URL(string: "http://localhost:4002/hapi-fhir-jpaserver/fhir/")! // DSTU2
	
	let client: Client
	
	// All possible states for this ViewModel
	enum State {
		case loading
		case error(String)
		case patient(Patient)
	}
	
	@Published var state: State
	
	init() {
		state = .loading
		
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
			self.readPatient()
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
}

struct PatientView: View {
	
	@StateObject var viewModel: PatientViewModel
	
	var body: some View {
		VStack {
			switch viewModel.state {
				case .loading:
					Text("launch_loading")
					
				case .error(let error):
					HStack {
						Text(error)
					}
					.frame(maxWidth: .infinity)
					.border(.red, width: 2)
				
				case .patient(let patient):
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
					.rijksoverheidStyle(font: .regular, style: .body)
			}
		}
		.onAppear {
			viewModel.start()
		}
	}
}

#Preview {
    PatientView(viewModel: PatientViewModel())
}
