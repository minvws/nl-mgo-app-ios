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
	
//	let patientID = "2e27c71e-30c8-4ceb-8c1c-5641e066c0a4" // STU3
//	let serverURL = URL(string: "http://localhost:4003/hapi-fhir-jpaserver/fhir/")! // STU3
	
		let patientID = "216146" // R4
		let serverURL = URL(string: "http://localhost:4004/hapi-fhir-jpaserver/fhir/")! // R4
	
	let client: Client
	
	@Published var name: String?
	
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
	
		client.authorize { _, error in
			DispatchQueue.main.async {
				guard error == nil else {
					logError("Client authorize error: \(String(describing: error))")
					self.errorLog = error.debugDescription
					self.isLoading = false
					return
				}
			}
			self.readPatient()
		}
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
				}
			}
		}
	}
}

struct PatientView: View {
	
	@StateObject var viewModel: PatientViewModel
	
	var body: some View {
		VStack {
			if let name = viewModel.name {
				Text(name)
			} else {
				if viewModel.isLoading {
					Text("launch_loading")
				} else {
					Text(verbatim: "No name found")
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
