/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import SharedCore
import MGOTest

final class R4NlCoreNameInformationFactoryTests: XCTestCase {
	
	func test_R4NlCoreNameInformation() {
		
		// Given
		let sut = R4NlCoreHealthProfessionalPractitioner(
			address: nil,
			birthDate: nil,
			communication: nil,
			emailAddresses: nil,
			fhirVersion: FhirVersionR4.r4,
			gender: nil,
			id: "test",
			identifier: nil,
			name: [NameElement(
				family: nil,
				given: nil,
				givenInitials: nil,
				givenNames: nil,
				nameUsage: nil,
				period: nil,
				r4NlCoreNameInformationPrefix: nil,
				suffix: nil,
				text: "Test",
				use: .official
			)],
			profile: R4NlCoreHealthProfessionalPractitionerProfile.httpNictizNlFhirStructureDefinitionNlCoreHealthProfessionalPractitioner,
			qualification: nil,
			referenceID: "referenceID",
			resourceType: nil,
			telephoneNumbers: nil
		)
		
		// When
		let casted = sut.nameElements
		
		// Then
		expect(casted?.count) == 1
		expect(casted?.first as? R4NlCoreNameInformation) != nil
		expect(casted?.first as? R4NlCoreNameInformationGiven) == nil
	}
	
	func test_R4NlCoreNameInformationGiven() {
		
		// Given
		let sut = R4NlCoreHealthProfessionalPractitioner(
			address: nil,
			birthDate: nil,
			communication: nil,
			emailAddresses: nil,
			fhirVersion: FhirVersionR4.r4,
			gender: nil,
			id: "test",
			identifier: nil,
			name: [NameElement(
				family: nil,
				given: nil,
				givenInitials: nil,
				givenNames: nil,
				nameUsage: nil,
				period: nil,
				r4NlCoreNameInformationPrefix: nil,
				suffix: nil,
				text: "Test",
				use: .usual
			)],
			profile: R4NlCoreHealthProfessionalPractitionerProfile.httpNictizNlFhirStructureDefinitionNlCoreHealthProfessionalPractitioner,
			qualification: nil,
			referenceID: "referenceID",
			resourceType: nil,
			telephoneNumbers: nil
		)
		
		// When
		let casted = sut.nameElements
		
		// Then
		expect(casted?.count) == 1
		expect(casted?.first as? R4NlCoreNameInformation) == nil
		expect(casted?.first as? R4NlCoreNameInformationGiven) != nil
	}
}
