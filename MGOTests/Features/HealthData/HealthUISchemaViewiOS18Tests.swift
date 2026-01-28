/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO
final class HealthUISchemaViewiOS18Tests: XCTestCase {
	
	private var healthcareOrganization: MgoOrganization!
	private var sut: HealthUISchemaView!
	
	override func setUp() {
		super.setUp()
		healthcareOrganization = Generator.healthcareOrganization("1")
	}
	
	@MainActor func setupSut(
		_ resource: String,
		resolvedReferences: [String: Bool] = [:]
	) throws {
		
		let data = try getResource(resource)
		let schema = try HealthUISchema(data: data)
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		sut = HealthUISchemaView(
			schema: schema,
			healthcareOrganization: healthcareOrganization,
			resolvedReferences: resolvedReferences,
			resolvedCodes: [:]
		)
	}
	
	@MainActor func test_HealthUISchemaView_singleEntry() throws {
		
		// Given
		try setupSut("singleEntry")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_singleNullEntry() throws {
		
		// Given
		try setupSut("singleNullEntry")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_singleEntry_noSectionHeader() throws {
		
		// Given
		try setupSut("singleEntryNoSectionHeader")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_downloadLink() throws {
		
		// Given
		try setupSut("downloadLink")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_downloadBinary() throws {
		
		// Given
		try setupSut("downloadBinary", resolvedReferences: ["reference": true])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_referenceLink() throws {
		
		// Given
		try setupSut("referenceLink", resolvedReferences: ["reference/link": true])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_referenceLink_unresolved() throws {
		
		// Given
		try setupSut("referenceLink")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_reference() throws {
		
		// Given
		try setupSut("reference", resolvedReferences: ["reference/link": true])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_reference_displayNull() throws {
		
		// Given
		try setupSut("referenceWithoutDisplay", resolvedReferences: ["reference/link": true])
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_reference_unresolved() throws {
		
		// Given
		try setupSut("reference")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_reference_displayNull_unresolved() throws {
		
		// Given
		try setupSut("referenceWithoutDisplay")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleValues_singleEntry() throws {
		
		// Given
		try setupSut("multipleValuesSingleEntry")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleValues_multipleEntries() throws {
		
		// Given
		try setupSut("multipleValuesMultipleEntries")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleGroupValues_singleEntry() throws {
		
		// Given
		try setupSut("multipleGroupValuesSingleEntry")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleGroupValues_multipleEntries() throws {
		
		// Given
		try setupSut("multipleGroupValuesMultipleEntries")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleGroupValues_mixedEntries() throws {
		
		// Given
		try setupSut("multipleGroupValuesMixedEntries")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_singleDisplayCode() throws {
		
		// Given
		try setupSut("singleDisplayCode")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_singleDisplayCode_resolved() throws {
		
		// Given
		try setupSut("singleDisplayCode")
		sut.resolvedCodes = ["code": true]
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleValuesDisplayCode() throws {
		
		// Given
		try setupSut("multipleValuesDisplayCode")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleValuesDisplayCode_oneCodeResolved() throws {
		
		// Given
		try setupSut("multipleValuesDisplayCode")
		sut.resolvedCodes = ["1234": true]
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleValuesDisplayCode_otherCodeResolved() throws {
		
		// Given
		try setupSut("multipleValuesDisplayCode")
		sut.resolvedCodes = ["5678": true]
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleValuesDisplayCode_allCodesResolved() throws {
		
		// Given
		try setupSut("multipleValuesDisplayCode")
		sut.resolvedCodes = ["1234": true, "5678": true]
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleGroupValuesMultipleDisplayCode() throws {
		
		// Given
		try setupSut("multipleGroupValuesMultipleDisplayCode")
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleGroupValuesMultipleDisplayCode_oneCodeResolved() throws {
		
		// Given
		try setupSut("multipleGroupValuesMultipleDisplayCode")
		sut.resolvedCodes = ["1234": true]
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleGroupValuesMultipleDisplayCode_otherCodeResolved() throws {
		
		// Given
		try setupSut("multipleGroupValuesMultipleDisplayCode")
		sut.resolvedCodes = ["5678": true]
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_HealthUISchemaView_multipleGroupValuesMultipleDisplayCode_allCodesResolved() throws {
		
		// Given
		try setupSut("multipleGroupValuesMultipleDisplayCode")
		sut.resolvedCodes = ["1234": true, "5678": true]
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
