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
	let serverURL = URL(string: "http://localhost:4003/hapi-fhir-jpaserver/fhir/")!
	
	let client: Client
	
	@Published var patient: Patient?
	
	@Published var errorLog: String?
	
	@Published var isLoading: Bool = false
	
	init() {
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
				self.isLoading = false
				
				guard error == nil else {
					logError("Client read error: \(String(describing: error))")
					self.errorLog = error.debugDescription
					return
				}
				
				if let patient = resource as? Patient {
					self.patient = patient
				}
			}
		}
	}
}

struct PatientView: View {
	
	@StateObject var viewModel: PatientViewModel
	
	var body: some View {
		VStack {
			if viewModel.isLoading {
				Text("launch_loading")
			} else {
				
				VStack(alignment: .leading) {
				
					Text(verbatim: "Patient ID: ") + Text(viewModel.patientID)
					if let name = viewModel.patient?.humanName {
						Text(verbatim: "Naam: ") + Text(name)
					}
					if let birthday = viewModel.patient?.humanBirthDateMedium {
						Text(verbatim: "Geboortedatum: ") + Text(birthday)
					}
					if let email = viewModel.patient?.email {
						Text(verbatim: "Email: ") + Text(email)
					}
				}
				.rijksoverheidStyle(font: .regular, style: .body)
			}
			
			if let error = viewModel.errorLog {
				HStack {
					Text(error)
				}
				.frame(maxWidth: .infinity)
				.border(.red, width: 2)
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
