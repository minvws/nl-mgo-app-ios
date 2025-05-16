/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import SharedCore
import MGOTest

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
		expect(object?.asAgreedIndicator) == true
		expect(object?.author?.display) == "Vaste Huisarts 1 || Huisartsen || Maatschap Vaste Huisarts"
		expect(object?.author?.reference) == "PractitionerRole/nl-core-practitionerrole-02"
		expect(object?.category?.coding.first?.code) == "6"
		expect(object?.category?.coding.first?.display) == "Medicatiegebruik"
		expect(object?.category?.coding.first?.system) == "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3"
		expect(object?.category?.text) == "Medicatiegebruik"
		expect(object?.dateAsserted) == "2020-07-21"
		expect(object?.dosage?.first?.additionalInstruction) == nil
		expect(object?.dosage?.first?.asNeeded?.coding.first?.code) == "1137"
		expect(object?.dosage?.first?.asNeeded?.coding.first?.display) == "zo nodig"
		expect(object?.dosage?.first?.asNeeded?.coding.first?.system) == "https://referentiemodel.nhg.org/tabellen/nhg-tabel-25-gebruiksvoorschrift#aanvullend-numeriek"
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
		expect(object?.dosage?.first?.route?.coding.first?.code) == "9"
		expect(object?.dosage?.first?.route?.coding.first?.display) == "ORAAL"
		expect(object?.dosage?.first?.route?.coding.first?.system) == "urn:oid:2.16.840.1.113883.2.4.4.9"
		expect(object?.dosage?.first?.sequence) == 1
		expect(object?.dosage?.first?.text) == "Vanaf 21 jul 2020, gedurende 30 dagen, zo nodig maal per dag 1 à 2 stuks , maximaal 6 stuks per dag, ORAAL"
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.boundsDuration) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.boundsPeriod) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.boundsRange) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.dayOfWeek) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.duration) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.durationUnit) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.frequency) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.frequencyMax) == 4.0
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.period) == 1.0
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.periodUnit) == "d"
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.timeOfDay) == nil
		expect(object?.dosage?.first?.timing.zibAdministrationScheduleRepeat.when) == nil
		expect(object?.effectiveDuration?.code) == "d"
		expect(object?.effectiveDuration?.comparator) == nil
		expect(object?.effectiveDuration?.system) == "http://unitsofmeasure.org"
		expect(object?.effectiveDuration?.unit) == "dag"
		expect(object?.effectiveDuration?.value) == 30.0
		expect(object?.effectivePeriod?.start) == "2020-07-21"
		expect(object?.effectivePeriod?.end) == nil
		expect(object?.fhirVersion) == FhirVersionR3.r3
		expect(object?.id) == "zib-medicationuse-01"
		expect(object?.identifier?.first?.system) == "urn:oid:2.16.840.1.113883.2.4.3.11.999.77.6.1"
		expect(object?.identifier?.first?.type) == nil
		expect(object?.identifier?.first?.use) == nil
		expect(object?.identifier?.first?.value) == "#MB_01i1#GE_01"
		expect(object?.identifier?.last?.system) == "urn:oid:2.16.840.1.113883.2.4.3.11.999.7.6"
		expect(object?.identifier?.last?.type) == nil
		expect(object?.identifier?.last?.use) == nil
		expect(object?.identifier?.last?.value) == "1bfa2275-8fdf-11ec-2032-020000000000"
		expect(object?.informationSource) == nil
		expect(object?.medicationReference?.display) == "PARACETAMOL TABLET 500MG"
		expect(object?.medicationReference?.reference) == "Medication/zib-Product-02"
		expect(object?.medicationTreatment?.system) == "urn:oid:2.16.840.1.113883.2.4.3.11.999.77.1.1"
		expect(object?.medicationTreatment?.type) == nil
		expect(object?.medicationTreatment?.use) == nil
		expect(object?.medicationTreatment?.value) == "#MB_01i1"
		expect(object?.note) == nil
		expect(object?.prescriber) == nil
		expect(object?.profile.rawValue) == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse"
		expect(object?.reasonCode) == nil
		expect(object?.reasonForChangeOrDiscontinuationOfUse) == nil
		expect(object?.referenceID) == "MedicationStatement/zib-medicationuse-01"
		expect(object?.repeatPeriodCyclicalSchedule) == nil
		expect(object?.resourceType) == "MedicationStatement"
		expect(object?.status?.rawValue) == "completed"
		expect(object?.subject?.display) == "XXX_Helleman"
		expect(object?.subject?.reference) == "Patient/nl-core-patient-01"
		expect(object?.taken?.rawValue) == "y"
	}
}
