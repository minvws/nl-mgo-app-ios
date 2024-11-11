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
import Zibs

final class UISchemaDetailsViewTests: XCTestCase {
	
	func test_UISchemaDetailsView_singleEntry() throws {
		
		// Given
		let data = try getResource("singleEntry")
		let schema = try UISchema(data: data)
		let sut = UISchemaView(schema: schema)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_singleNullEntry() throws {
		
		// Given
		let data = try getResource("singleNullEntry")
		let schema = try UISchema(data: data)
		let sut = UISchemaView(schema: schema)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_downloadLink() throws {
		
		// Given
		let data = try getResource("downloadLink")
		let schema = try UISchema(data: data)
		let sut = UISchemaView(schema: schema)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_reference() throws {
		
		// Given
		let data = try getResource("reference")
		let schema = try UISchema(data: data)
		let sut = UISchemaView(schema: schema)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleValues_singleEntry() throws {
		
		// Given
		let data = try getResource("multipleValuesSingleEntry")
		let schema = try UISchema(data: data)
		let sut = UISchemaView(schema: schema)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleValues_multipleEntries() throws {
		
		// Given
		let data = try getResource("multipleValuesMultipleEntries")
		let schema = try UISchema(data: data)
		let sut = UISchemaView(schema: schema)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleGroupValues_singleEntry() throws {
		
		// Given
		let data = try getResource("multipleGroupValuesSingleEntry")
		let schema = try UISchema(data: data)
		let sut = UISchemaView(schema: schema)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleGroupValues_multipleEntries() throws {
		
		// Given
		let data = try getResource("multipleGroupValuesMultipleEntries")
		let schema = try UISchema(data: data)
		let sut = UISchemaView(schema: schema)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_UISchemaDetailsView_multipleGroupValues_mixedEntries() throws {
		
		// Given
		let data = try getResource("multipleGroupValuesMixedEntries")
		let schema = try UISchema(data: data)
		let sut = UISchemaView(schema: schema)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
