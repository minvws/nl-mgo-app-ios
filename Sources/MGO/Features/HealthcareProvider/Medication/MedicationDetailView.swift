/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct MedicationDetailView: View {
	
	var statement: MedicationStatement
	
	var body: some View {
		
		AccordionView(title: statement.medicationName ?? "") {
			VStack(alignment: .leading, spacing: 16) {
				if let dosageText = statement.dosageText {
					DetailRow(title: "medication_details_dosage", content: dosageText)
				}
				if let startDate = statement.startDate {
					DetailRow(title: "medication_details_startdate", content: startDate)
				}
				if let endDate = statement.endDate {
					DetailRow(title: "medication_details_enddate", content: endDate)
				}
				if let prescriber = statement.prescriber {
					DetailRow(title: "medication_details_prescriber", content: prescriber)
				}
			}
		}
	}
}

extension MedicationStatement {
	
	var medicationName: String? {
		
		if case .reference(let ref) = medication {
			return ref.display?.value?.string
		}
		if case .codeableConcept(let cc) = medication {
			return cc.text?.value?.string
		}
		return nil
	}
	
	var dosageText: String? {
		
		return dosage?.compactMap { $0.text?.value?.string }.joined()
	}
	
	var startDate: String? {
		
		var date: Date?
		do {
			if case .period(let period) = self.effective {
				date = try  period.start?.value?.date.asNSDate()
			}
			if case .dateTime(let dateTime) = self.effective {
				date = try dateTime.value?.asNSDate()
			}
			
			guard let date else { return nil }
			
			let formatter = DateFormatter()
			formatter.dateStyle = .long
			formatter.timeStyle = .none
	
			return formatter.string(from: date)
		} catch {
			return nil
		}
	}
	
	var endDate: String? {
		
		var date: Date?
		do {
			if case .period(let period) = self.effective {
				date = try  period.end?.value?.date.asNSDate()
			}
			
			guard let date else { return nil }
			
			let formatter = DateFormatter()
			formatter.dateStyle = .long
			formatter.timeStyle = .none
	
			return formatter.string(from: date)
		} catch {
			return nil
		}
	}
	
	var prescriber: String? {
		
		guard let ext = extensions(for: "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse-Prescriber").first else { return nil }
		
		if case .reference(let ref) = ext.value {
			return ref.display?.value?.string
		}
		return nil
	}
}
