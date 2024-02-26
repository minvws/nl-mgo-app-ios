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
	
	@Published var name: String?

	@Published var email: String?

	@Published var birthday: String?
	
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
					self.name = patient.humanName
					self.email = patient.getEmail()
					self.birthday = nil
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
					if let name = viewModel.name {
						Text(verbatim: "Naam: ") + Text(name)
					}
					if let birthday = viewModel.birthday {
						Text(verbatim: "Geboortedatum: ") + Text(birthday)
					}
					if let email = viewModel.email {
						Text(verbatim: "Email: ") + Text(email)
					}
				}
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
