/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import SharedCore
import MGOTest

@MainActor
final class ZibsTests: XCTestCase {
	
	func test_factory_invalidData() throws {
		
		// Given
		let resource = try getStringResource("invalid")
		let data = Data(resource.utf8)
		
		// When
		let object = ZibFactory.createZibMedicationUse(data)
		
		// Then
		expect(object) == nil
	}
	
	func test_factory_zibMedicationUse() throws {
		
		// Given
		let resource = try getStringResource("zibMedicationUse")
		let data = Data(resource.utf8)
		
		// When
		let object = ZibFactory.createZibMedicationUse(data)
		
		// Then
		expectAsAgreedIndicator(object)
		expectDateAsserted(object)
		expectDosage(object)
		expectEffectivePeriod(object)
		expectFhirVersion(object)
		expectId(object)
		expectIdentifier(object)
		expectInformationSource(object)
		expectMedicationReference(object)
		expectMedicationTreatment(object)
		expectNote(object)
		expectPrescriber(object)
		expectProfile(object)
		expectReasonCode(object)
		expectReasonForChangeOrDiscontinuationOfUse(object)
		expectReferenceID(object)
		expectRepeatPeriodCyclicalSchedule(object)
		expectResourceType(object)
		expectStatus(object)
		expectSubject(object)
		expectTaken(object)
	}
	
	private func expectAsAgreedIndicator(_ object: ZibMedicationUse?) {
		expect(object?.asAgreedIndicator?.ext) == true
		expect(object?.asAgreedIndicator?.type) == .boolean
		expect(object?.asAgreedIndicator?.value) == true
	}
	
	private func expectAuthor(_ object: ZibMedicationUse?) {
		expect(object?.author?.ext) == true
		expect(object?.author?.type) == .reference
		expect(object?.author?.display) == "Vaste Huisarts 1 || Huisartsen || Maatschap Vaste Huisarts"
		expect(object?.author?.reference) == "PractitionerRole/nl-core-practitionerrole-02"
	}
	
	private func expectDateAsserted(_ object: ZibMedicationUse?) {
		expect(object?.dateAsserted?.type) == .dateTime
		expect(object?.dateAsserted?.value) == "2020-07-21"
	}
	
	private func expectDosage(_ object: ZibMedicationUse?) {
		expect(object?.dosage?.count) == 1
		expect(object?.dosage?.first?.profile.rawValue) == "http://nictiz.nl/fhir/StructureDefinition/zib-InstructionsForUse"
		expect(object?.dosage?.first?.additionalInstruction) == nil
		expect(object?.dosage?.first?.asNeededCodeableConcept?.coding.count) == 1
		expect(object?.dosage?.first?.asNeededCodeableConcept?.coding.first?.code) == "1137"
		expect(object?.dosage?.first?.asNeededCodeableConcept?.coding.first?.display) == "zo nodig"
		expect(object?.dosage?.first?.asNeededCodeableConcept?.coding.first?.system) == "https://referentiemodel.nhg.org/tabellen/nhg-tabel-25-gebruiksvoorschrift#aanvullend-numeriek"
		expect(object?.dosage?.first?.doseQuantity) == nil
		expect(object?.dosage?.first?.doseRange?.high?.code) == "245"
		expect(object?.dosage?.first?.doseRange?.high?.comparator) == nil
		expect(object?.dosage?.first?.doseRange?.high?.system) == "urn:oid:2.16.840.1.113883.2.4.4.1.900.2"
		expect(object?.dosage?.first?.doseRange?.high?.unit) == "Stuk"
		expect(object?.dosage?.first?.doseRange?.high?.value) == 2.0
		expect(object?.dosage?.first?.doseRange?.low?.code) == "245"
		expect(object?.dosage?.first?.doseRange?.low?.comparator) == nil
		expect(object?.dosage?.first?.doseRange?.low?.system) == "urn:oid:2.16.840.1.113883.2.4.4.1.900.2"
		expect(object?.dosage?.first?.doseRange?.low?.unit) == "Stuk"
		expect(object?.dosage?.first?.doseRange?.low?.value) == 1.0
		expect(object?.dosage?.first?.maxDosePerPeriod?.denominator?.code) == "d"
		expect(object?.dosage?.first?.maxDosePerPeriod?.denominator?.comparator) == nil
		expect(object?.dosage?.first?.maxDosePerPeriod?.denominator?.system) == "http://unitsofmeasure.org"
		expect(object?.dosage?.first?.maxDosePerPeriod?.denominator?.unit) == "dag"
		expect(object?.dosage?.first?.maxDosePerPeriod?.denominator?.value) == 1.0
		expect(object?.dosage?.first?.maxDosePerPeriod?.numerator?.code) == "245"
		expect(object?.dosage?.first?.maxDosePerPeriod?.numerator?.comparator) == nil
		expect(object?.dosage?.first?.maxDosePerPeriod?.numerator?.system) == "urn:oid:2.16.840.1.113883.2.4.4.1.900.2"
		expect(object?.dosage?.first?.maxDosePerPeriod?.numerator?.unit) == "Stuk"
		expect(object?.dosage?.first?.maxDosePerPeriod?.numerator?.value) == 6.0
		expect(object?.dosage?.first?.rateQuantity) == nil
		expect(object?.dosage?.first?.rateRatio) == nil
		expect(object?.dosage?.first?.rateRange) == nil
		expect(object?.dosage?.first?.route?.text) == nil
		expect(object?.dosage?.first?.route?.coding.count) == 1
		expect(object?.dosage?.first?.route?.coding.first?.code) == "9"
		expect(object?.dosage?.first?.route?.coding.first?.display) == "ORAAL"
		expect(object?.dosage?.first?.route?.coding.first?.system) == "urn:oid:2.16.840.1.113883.2.4.4.9"
		expect(object?.dosage?.first?.sequence?.value) == 1
		expect(object?.dosage?.first?.text?.value) == "Vanaf 21 jul 2020, gedurende 30 dagen, zo nodig maal per dag 1 à 2 stuks , maximaal 6 stuks per dag, ORAAL"
		expect(object?.dosage?.first?.timing.profile.rawValue) == "http://nictiz.nl/fhir/StructureDefinition/zib-AdministrationSchedule"
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.boundsDuration) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.boundsPeriod) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.boundsRange) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.dayOfWeek) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.duration) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.durationUnit) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.frequency) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.frequencyMax?.value) == 4.0
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.period?.value) == 1.0
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.periodUnit?.value) == "d"
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.timeOfDay) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.when) == nil
	}
	
	private func expectEffectivePeriod(_ object: ZibMedicationUse?) {
		expect(object?.effectivePeriod.type) == .period
		expect(object?.effectivePeriod.duration?.ext) == true
		expect(object?.effectivePeriod.duration?.type) == .duration
		expect(object?.effectivePeriod.duration?.code) == "d"
		expect(object?.effectivePeriod.duration?.comparator) == nil
		expect(object?.effectivePeriod.duration?.system) == "http://unitsofmeasure.org"
		expect(object?.effectivePeriod.duration?.unit) == "dag"
		expect(object?.effectivePeriod.duration?.value) == 30
		expect(object?.effectivePeriod.start) == "2020-07-21"
		expect(object?.effectivePeriod.end) == nil
	}
	
	private func expectFhirVersion(_ object: ZibMedicationUse?) {
		expect(object?.fhirVersion) == FhirVersionR3.r3
	}
	
	private func expectId(_ object: ZibMedicationUse?) {
		expect(object?.id) == "zib-medicationuse-01"
	}
	
	private func expectIdentifier(_ object: ZibMedicationUse?) {
		expect(object?.identifier?.count) == 2
		expect(object?.identifier?.first?.system) == "urn:oid:2.16.840.1.113883.2.4.3.11.999.77.6.1"
		expect(object?.identifier?.first?.type) == .identifier
		expect(object?.identifier?.first?.mgoIdentifierType) == nil
		expect(object?.identifier?.first?.use) == nil
		expect(object?.identifier?.first?.value) == "#MB_01i1#GE_01"
		expect(object?.identifier?.last?.system) == "urn:oid:2.16.840.1.113883.2.4.3.11.999.7.6"
		expect(object?.identifier?.last?.type) == .identifier
		expect(object?.identifier?.last?.mgoIdentifierType) == nil
		expect(object?.identifier?.last?.use) == nil
		expect(object?.identifier?.last?.value) == "1bfa2275-8fdf-11ec-2032-020000000000"
	}
	
	private func expectInformationSource(_ object: ZibMedicationUse?) {
		expect(object?.informationSource?.type) == .reference
		expect(object?.informationSource?.display) == "Henk de Vries"
		expect(object?.informationSource?.reference) == "Practitioner/nl-core-practitioner-01"
	}
	
	private func expectMedicationReference(_ object: ZibMedicationUse?) {
		expect(object?.medicationReference?.type) == .reference
		expect(object?.medicationReference?.display) == "PARACETAMOL TABLET 500MG"
		expect(object?.medicationReference?.reference) == "Medication/zib-Product-02"
	}
	
	private func expectMedicationTreatment(_ object: ZibMedicationUse?) {
		expect(object?.medicationTreatment?.system) == "urn:oid:2.16.840.1.113883.2.4.3.11.999.77.1.1"
		expect(object?.medicationTreatment?.ext) == true
		expect(object?.medicationTreatment?.type) == .identifier
		expect(object?.medicationTreatment?.use) == nil
		expect(object?.medicationTreatment?.medicationTreatmentType) == nil
		expect(object?.medicationTreatment?.value) == "#MB_01i1"
	}
	
	private func expectNote(_ object: ZibMedicationUse?) {
		expect(object?.note?.count) == 1
		expect(object?.note?.first?.author) == nil
		expect(object?.note?.first?.type) == .annotation
		expect(object?.note?.first?.text) == "het monster toont afwijkingen"
		expect(object?.note?.first?.time) == "2020-03-01T22:03:00+00:00"
	}
	
	private func expectPrescriber(_ object: ZibMedicationUse?) {
		expect(object?.prescriber?.ext) == true
		expect(object?.prescriber?.type) == .reference
		expect(object?.prescriber?.display) == "Henk de Vries"
		expect(object?.prescriber?.reference) == "Practitioner/nl-core-practitioner-01"
	}
	
	private func expectProfile(_ object: ZibMedicationUse?) {
		expect(object?.profile.rawValue) == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse"
	}
	
	private func expectReasonCode(_ object: ZibMedicationUse?) {
		expect(object?.reasonCode?.count) == 1
		expect(object?.reasonCode?.first?.type) == .codeableConcept
		expect(object?.reasonCode?.first?.text) == nil
		expect(object?.reasonCode?.first?.coding.count) == 1
		expect(object?.reasonCode?.first?.coding.first?.code) == "9632001"
		expect(object?.reasonCode?.first?.coding.first?.display) == "Nursing Procedure"
		expect(object?.reasonCode?.first?.coding.first?.system) == "http://snomed.info/sct"
		expect(object?.reasonCode?.first?.text) == nil
	}
	
	private func expectReasonForChangeOrDiscontinuationOfUse(_ object: ZibMedicationUse?) {
		expect(object?.reasonForChangeOrDiscontinuationOfUse?.ext) == true
		expect(object?.reasonForChangeOrDiscontinuationOfUse?.type) == .codeableConcept
		expect(object?.reasonForChangeOrDiscontinuationOfUse?.coding.count) == 1
		expect(object?.reasonForChangeOrDiscontinuationOfUse?.coding.first?.code) == "79899007"
		expect(object?.reasonForChangeOrDiscontinuationOfUse?.coding.first?.display) == "Drug interaction (finding)"
		expect(object?.reasonForChangeOrDiscontinuationOfUse?.coding.first?.system) == "http://snomed.info/sct"
		expect(object?.reasonForChangeOrDiscontinuationOfUse?.text) == nil
	}
	
	private func expectReferenceID(_ object: ZibMedicationUse?) {
		expect(object?.referenceID) == "MedicationStatement/zib-medicationuse-01"
	}
	
	private func expectRepeatPeriodCyclicalSchedule(_ object: ZibMedicationUse?) {
		expect(object?.repeatPeriodCyclicalSchedule) == nil
	}
	
	private func expectResourceType(_ object: ZibMedicationUse?) {
		expect(object?.resourceType) == "MedicationStatement"
	}
	
	private func expectStatus(_ object: ZibMedicationUse?) {
		expect(object?.status?.type) == .code
		expect(object?.status?.value) == .completed
	}
	
	private func expectSubject(_ object: ZibMedicationUse?) {
		expect(object?.subject?.type) == .reference
		expect(object?.subject?.display) == "XXX_Helleman"
		expect(object?.subject?.reference) == "Patient/nl-core-patient-01"
	}
	
	private func expectTaken(_ object: ZibMedicationUse?) {
		expect(object?.taken?.type) == .code
		expect(object?.taken?.value) == .y
	}
}
