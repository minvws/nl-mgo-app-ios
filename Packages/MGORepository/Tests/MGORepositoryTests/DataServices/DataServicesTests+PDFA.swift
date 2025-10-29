/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import Testing
import Foundation

class DataServicesPDFATests {
	
	var sut: DataServices!
	
	init() {
		self.sut = DataServices()
	}
	
	@Test func documents() async throws {
		
		// Given
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "51" }))
		
		// Then
		#expect(dataService.id == "51")
		#expect(dataService.name == "Documents PDF/A")
		#expect(dataService.fhirVersion == "3.0")
		#expect(dataService.fhirVersionEnum == .r3)
		#expect(dataService.endpoints.count == 1)
		
		#expect(dataService.endpoints[0].id == "documentReference")
		#expect(dataService.endpoints[0].getPath() == "/DocumentReference")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://nictiz.nl/fhir/StructureDefinition/IHE.MHD.Minimal.DocumentReference")
	}
}
