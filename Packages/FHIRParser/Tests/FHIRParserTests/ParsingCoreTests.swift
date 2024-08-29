/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRParser
import Zibs

final class FHIRParserTests: XCTestCase {
	
	var sut: FHIRParser!
	
	override func setUp() {
		super.setUp()
		sut = FHIRParser()
	}
	
	func test_getBundleResourcesJson() throws {
		
		// Given
		let json = try getResource("bundle")
		
		// When
		let result = sut.getBundleResourcesJson(json)
		
		// Then
		expect(result).to(haveCount(2))
	}
	
	func test_getBundleResourcesJson_error() throws {
		
		// Given
		
		// When
		let result = sut.getBundleResourcesJson(Data("wrong".utf8))
		
		// Then
		expect(result).to(beEmpty())
	}
	
	func test_parseResourceJson() throws {
		
		// Given
		let resource = try getStringResource("medicationResource")
		let data = Data(resource.utf8)
		
		// When
		let zib = sut.getMgoResourceJson(data)
		
		// Then
		if let zib {
			let zibMedicationUse = ZibFactory.createZibMedicationUse(zib)
			expect(zibMedicationUse?.medication?.display) == "Zestril tablet 10mg"
		} else {
			fail("Could not unwrap zib")
		}
	}
	
	func test_parseResourceJson_error() throws {
		
		// Given
		
		// When
		let zib = sut.getMgoResourceJson(Data("wrong".utf8))
		
		// Then
		expect(zib) == Data("undefined".utf8)
	}
	
	func test_getUiSchemaJson() throws {
		
		// Given
		let resource = try getStringResource("zibMedicationUse")
		let data = Data(resource.utf8)
		
		// When
		let schema = sut.getUiSchemaJson(data)
		
		// Then
		expect(schema?.label) == "Zestril tablet 10mg"
	}
	
	func test_getUiSchemaJson_error() throws {
		
		// Given
		
		// When
		let schema = sut.getUiSchemaJson(Data("wrong".utf8))
		
		// Then
		expect(schema) == nil
	}
}
