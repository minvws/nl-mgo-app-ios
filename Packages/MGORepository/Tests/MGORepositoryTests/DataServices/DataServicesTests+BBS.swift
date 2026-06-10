/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import Testing
import Foundation

class DataServicesBBSTests {
	
	var sut: DataServices!
	
	init() {
		self.sut = DataServices()
	}
	
	@Test func documents() async throws {
		
		// Given
		
		// When
		let dataService = try #require(sut.services.first(where: { $0.id == "9000002" }))
		
		// Then
		#expect(dataService.id == "9000002")
		#expect(dataService.name == "Image Availability")
		#expect(dataService.fhirVersion == "4.0")
		#expect(dataService.fhirVersionEnum == .r4)
		#expect(dataService.endpoints.count == 1)
		
		#expect(dataService.endpoints[0].id == "imageAvailability")
		#expect(dataService.endpoints[0].getPath() == "/DocumentReference?status=current")
		#expect(dataService.endpoints[0].profiles.count == 1)
		#expect(dataService.endpoints[0].profiles.first == "http://medmij.nl/fhir/StructureDefinition/bbs-DocumentReference")
	}
}
