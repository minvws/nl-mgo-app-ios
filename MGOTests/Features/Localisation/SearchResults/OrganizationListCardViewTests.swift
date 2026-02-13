/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class OrganizationListCardViewTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
	}
	
	@MainActor func test_searchResultCardView_regular() {
		
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
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_searchResultCardView_selected() {
		
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
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_searchResultCardView_warning() {
		
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
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_searchResultCardView_nameOnly() {
		
		// Given
		
		// When
		let sut = OrganizationListCardView(
			model: OrganizationDisplayModel(
				id: "1",
				name: "Tandarts Tandje Erbij"
			),
			state: .regular
		)
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_searchResultCardView_noStreet() {
		
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
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_searchResultCardView_noPostalCode() {
		
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
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_searchResultCardView_automaticSelected() {
		
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
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_searchResultCardView_automaticUnselected() {
		
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
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: sut)
	}
}
