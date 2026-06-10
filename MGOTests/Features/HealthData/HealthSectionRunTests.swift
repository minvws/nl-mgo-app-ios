/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
@testable import MGO

struct HealthSectionRunTests {
	
	private struct FakeElement: UIElementProtocol {
		var elementType: String = "fake"
		var label: String = "label"
		var prefersFullWidth: Bool
	}
	
	@Test("Empty input produces no runs")
	func runs_emptyInput_returnsEmpty() {
		
		// Given
		let elements: [UIElementProtocol] = []
		
		// When
		let runs = HealthSectionRun.runs(from: elements)
		
		// Then
		#expect(runs.isEmpty)
	}
	
	@Test("Consecutive normal elements collapse into a single card, preserving order")
	func runs_allNormal_returnsSingleCardPreservingOrder() {
		
		// Given
		let elements: [UIElementProtocol] = [
			FakeElement(elementType: "a", prefersFullWidth: false),
			FakeElement(elementType: "b", prefersFullWidth: false)
		]
		
		// When
		let runs = HealthSectionRun.runs(from: elements)
		
		// Then
		#expect(runs.count == 1)
		guard case let .card(cardElements) = runs[0] else {
			Issue.record("expected a card run")
			return
		}
		#expect(cardElements.map(\.elementType) == ["a", "b"])
	}
	
	@Test("A full-width element in the middle splits the rows into card / full-width / card")
	func runs_fullWidthInMiddle_splitsCardFullWidthCard() {
		
		// Given
		let elements: [UIElementProtocol] = [
			FakeElement(prefersFullWidth: false),
			FakeElement(prefersFullWidth: true),
			FakeElement(prefersFullWidth: false)
		]
		
		// When
		let runs = HealthSectionRun.runs(from: elements)
		
		// Then
		#expect(runs.count == 3)
		guard case .card = runs[0] else {
			Issue.record("expected card")
			return
		}
		guard case .fullWidth = runs[1] else {
			Issue.record("expected fullWidth")
			return
		}
		guard case .card = runs[2] else { Issue.record("expected card"); return }
	}
	
	@Test("A leading full-width element does not emit an empty card before it")
	func runs_leadingFullWidth_doesNotEmitEmptyCard() {
		
		// Given
		let elements: [UIElementProtocol] = [
			FakeElement(prefersFullWidth: true),
			FakeElement(prefersFullWidth: false)
		]
		
		// When
		let runs = HealthSectionRun.runs(from: elements)
		
		// Then
		#expect(runs.count == 2)
		guard case .fullWidth = runs[0] else {
			Issue.record("expected fullWidth")
			return
		}
		guard case .card = runs[1] else {
			Issue.record("expected card")
			return
		}
	}
	
	@Test("A trailing full-width element does not emit an empty card after it")
	func runs_trailingFullWidth_doesNotEmitEmptyCard() {
		
		// Given
		let elements: [UIElementProtocol] = [
			FakeElement(prefersFullWidth: false),
			FakeElement(prefersFullWidth: true)
		]
		
		// When
		let runs = HealthSectionRun.runs(from: elements)
		
		// Then
		#expect(runs.count == 2)
		guard case .card = runs[0] else {
			Issue.record("expected card")
			return
		}
		guard case .fullWidth = runs[1] else {
			Issue.record("expected fullWidth")
			return
		}
	}
	
	@Test("Consecutive full-width elements each get their own run")
	func runs_consecutiveFullWidth_eachOwnRun() {
		
		// Given
		let elements: [UIElementProtocol] = [
			FakeElement(prefersFullWidth: true),
			FakeElement(prefersFullWidth: true)
		]
		
		// When
		let runs = HealthSectionRun.runs(from: elements)
		
		// Then
		#expect(runs.count == 2)
		guard case .fullWidth = runs[0] else {
			Issue.record("expected fullWidth")
			return
		}
		guard case .fullWidth = runs[1] else {
			Issue.record("expected fullWidth")
			return
		}
	}
	
	@Test("A concrete element defaults to not full-width")
	func concreteType_defaultsToNotFullWidth() {
		
		// Given
		let single = SingleValue(
			id: "x",
			label: "l",
			type: .singleValue,
			value: nil
		)
		
		// When
		
		// Then
		#expect(single.prefersFullWidth == false)
	}
}
