/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import Zibs
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
		expect(object?.author) == nil
		expect(object?.category?.coding.first?.code) == "6"
		expect(object?.category?.coding.first?.display) == "Medicatiegebruik"
		expect(object?.category?.coding.first?.system) == "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3"
		expect(object?.category?.text) == nil
		expect(object?.dateAsserted) == "2018-08-16"
		expect(object?.dosage?.first?.additionalInstruction) == nil
		expect(object?.dosage?.first?.asNeeded) == nil
		expect(object?.dosage?.first?.doseQuantity?.value) == 1
		expect(object?.dosage?.first?.doseQuantity?.comparator) == nil
		expect(object?.dosage?.first?.doseQuantity?.unit) == "stuk"
		expect(object?.dosage?.first?.doseQuantity?.system) == "urn:oid:2.16.840.1.113883.2.4.4.1.900.2"
		expect(object?.dosage?.first?.doseQuantity?.code) == "245"
		expect(object?.dosage?.first?.doseRange) == nil
		expect(object?.dosage?.first?.maxDosePerPeriod) == nil
		expect(object?.dosage?.first?.rateRatio) == nil
		expect(object?.dosage?.first?.rateRange) == nil
		expect(object?.dosage?.first?.rateQuantity) == nil
		expect(object?.dosage?.first?.route?.text) == nil
		expect(object?.dosage?.first?.route?.coding.first?.code) == "9"
		expect(object?.dosage?.first?.route?.coding.first?.display) == "Oraal"
		expect(object?.dosage?.first?.route?.coding.first?.system) == "urn:oid:2.16.840.1.113883.2.4.4.9"
		expect(object?.dosage?.first?.sequence) == 1
		expect(object?.dosage?.first?.text) == "1 maal per dag 1 tablet, oraal"
		expect(object?.dosage?.first?.timing.boundsDuration) == nil
		expect(object?.dosage?.first?.timing.boundsPeriod) == nil
		expect(object?.dosage?.first?.timing.boundsRange) == nil
		expect(object?.dosage?.first?.timing.duration) == nil
		expect(object?.dosage?.first?.timing.durationUnit) == nil
		expect(object?.dosage?.first?.timing.frequency) == 1
		expect(object?.dosage?.first?.timing.frequencyMax) == nil
		expect(object?.dosage?.first?.timing.period) == 1
		expect(object?.dosage?.first?.timing.periodUnit) == "d"
		expect(object?.dosage?.first?.timing.dayOfWeek) == nil
		expect(object?.dosage?.first?.timing.timeOfDay) == nil
		expect(object?.dosage?.first?.timing.when) == nil
		expect(object?.effectiveDuration?.value) == 3
		expect(object?.effectiveDuration?.comparator) == nil
		expect(object?.effectiveDuration?.unit) == "week"
		expect(object?.effectiveDuration?.system) == "http://unitsofmeasure.org"
		expect(object?.effectiveDuration?.code) == "wk"
		expect(object?.effectivePeriod?.start) == "2018-06-28"
		expect(object?.effectivePeriod?.end) == nil
		expect(object?.fhirVersion) == Zibs.FhirVersionR3.r3
		expect(object?.id) == "cafa8f45-74bc-4107-a6f8-6eb58c6ed670"
		expect(object?.identifier?.first?.system) == "http://example-implementer.com/fhir/MedicationUseID"
		expect(object?.identifier?.first?.type) == nil
		expect(object?.identifier?.first?.use) == nil
		expect(object?.identifier?.first?.value) == "123457000000"
		expect(object?.informationSource?.display) == "Johan XXX_Helleman"
		expect(object?.informationSource?.reference) == "Patient/93cde269-ce35-4077-a39d-19296670e949"
		expect(object?.medicationReference?.display) == "Zestril tablet 10mg"
		expect(object?.medicationReference?.reference) == "Medication/8f017a48-fdab-42f5-a2d7-f7bb6d84a762"
		expect(object?.medicationTreatment) == nil
		expect(object?.note) == nil
		expect(object?.prescriber?.display) == "Huisartsen, niet nader gespecificeerd"
		expect(object?.prescriber?.reference) == "PractitionerRole/1a249336-3fe7-488f-bc88-44bc8e1ad2aa"
		expect(object?.profile.rawValue) == "http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse"
		expect(object?.reasonCode) == nil
		expect(object?.reasonForChangeOrDiscontinuationOfUse) == nil
		expect(object?.referenceID) == "MedicationStatement/cafa8f45-74bc-4107-a6f8-6eb58c6ed670"
		expect(object?.repeatPeriodCyclicalSchedule) == nil
		expect(object?.resourceType) == "MedicationStatement"
		expect(object?.status) == "active"
		expect(object?.subject?.display) == "Johan XXX_Helleman"
		expect(object?.subject?.reference) == "Patient/93cde269-ce35-4077-a39d-19296670e949"
		expect(object?.taken) == "y"
	}
}
