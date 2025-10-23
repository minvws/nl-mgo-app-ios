/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import Testing
import Foundation

class DataServicesVaccinationTests {
	
	var sut: DataServices!
	
	init() {
		self.sut = DataServices()
	}
	
	@Test func vaccinations() async throws {
		
		// Given
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "63" }))
		
		// Then
		#expect(dataService.id == "63")
		#expect(dataService.name == "Vaccination Immunization")
		#expect(dataService.fhirVersion == "4.0")
		#expect(dataService.fhirVersionEnum == .r4)
		#expect(dataService.endpoints.count == 1)
		
		#expect(dataService.endpoints[0].id == "vaccination")
		#expect(dataService.endpoints[0].getPath() == "/Immunization")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/nl-core-Vaccination-event")
	}
}
