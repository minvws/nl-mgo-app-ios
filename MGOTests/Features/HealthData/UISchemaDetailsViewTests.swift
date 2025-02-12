/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
final class UISchemaDetailsViewTests: XCTestCase {
	
	private var healthcareOrganization: MgoOrganization!
	private var sut: UISchemaView!
	
	override func setUp() {
		super.setUp()
		healthcareOrganization = Generator.healthcareOrganization("1")
	}
	
	func setupSut(_ resource: String, resolvedReferences: [String: Bool] = [:]) throws {
		
		let data = try getResource(resource)
		let schema = try UISchema(data: data)
		sut = UISchemaView(
			schema: schema,
			healthcareOrganization: healthcareOrganization,
			resolvedReferences: resolvedReferences
		)
	}
	
	func test_UISchemaDetailsView_singleEntry() throws {
		
		// Given
		try setupSut("singleEntry")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_singleNullEntry() throws {
		
		// Given
		try setupSut("singleNullEntry")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_singleEntry_noSectionHeader() throws {
		
		// Given
		try setupSut("singleEntryNoSectionHeader")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_downloadLink() throws {
		
		// Given
		try setupSut("downloadLink")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_downloadBinary() throws {
		
		// Given
		try setupSut("downloadBinary", resolvedReferences: ["reference": true])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_reference() throws {
		
		// Given
		try setupSut("reference", resolvedReferences: ["reference/link": true])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_referenceLink() throws {
		
		// Given
		try setupSut("referenceLink", resolvedReferences: ["reference/link": true])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_reference_unresolved() throws {
		
		// Given
		try setupSut("reference")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_referenceLink_unresolved() throws {
		
		// Given
		try setupSut("referenceLink")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleValues_singleEntry() throws {
		
		// Given
		try setupSut("multipleValuesSingleEntry")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleValues_multipleEntries() throws {
		
		// Given
		try setupSut("multipleValuesMultipleEntries")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleGroupValues_singleEntry() throws {
		
		// Given
		try setupSut("multipleGroupValuesSingleEntry")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleGroupValues_multipleEntries() throws {
		
		// Given
		try setupSut("multipleGroupValuesMultipleEntries")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleGroupValues_mixedEntries() throws {
		
		// Given
		try setupSut("multipleGroupValuesMixedEntries")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
