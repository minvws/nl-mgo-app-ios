/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class SearchResultCardViewTests: XCTestCase {

	func test_searchResultCardView_regular() {
		
		// Given
		
		// When
		let sut = SearchResultCardView(
			element: SearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .regular
		)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_searchResultCardView_selected() {
		
		// Given
		
		// When
		let sut = SearchResultCardView(
			element: SearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .selected
		)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_searchResultCardView_warning() {
		
		// Given
		
		// When
		let sut = SearchResultCardView(
			element: SearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .warning
		)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_searchResultCardView_nameOnly() {
		
		// Given
		
		// When
		let sut = SearchResultCardView(
			element: SearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij"
			),
			state: .regular
		)
		
		// Then
		takeSnapShots(content: sut)
	}
}
