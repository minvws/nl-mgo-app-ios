/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO

final class OrganizationListCardViewTests: XCTestCase {
	
	func test_searchResultCardView_regular() {
		
		// Given
		
		// When
		let sut = OrganizationListCardView(
			model: OrganizationDisplayModel(
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
		let sut = OrganizationListCardView(
			model: OrganizationDisplayModel(
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
		let sut = OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .notParticipating
		)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_searchResultCardView_nameOnly() {
		
		// Given
		
		// When
		let sut = OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandarts Tandje Erbij"
			),
			state: .regular
		)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_searchResultCardView_noStreet() {
		
		// Given
		
		// When
		let sut = OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: nil,
				postalCode: "1234AB"
			),
			state: .regular
		)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_searchResultCardView_noPostalCode() {
		
		// Given
		
		// When
		let sut = OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: nil
			),
			state: .regular
		)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_searchResultCardView_automaticSelected() {
		
		// Given
		
		// When
		let sut = OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .automatic(isSelected: true)
		)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_searchResultCardView_automaticUnselected() {
		
		// Given
		
		// When
		let sut = OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .automatic(isSelected: false)
		)
		
		// Then
		takeSnapShots(content: sut)
	}
}
