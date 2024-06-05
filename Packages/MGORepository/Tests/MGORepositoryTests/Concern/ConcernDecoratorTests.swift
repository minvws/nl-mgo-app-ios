/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import XCTest
import Nimble

final class ConcernDecoratorTests: XCTestCase {
	
	func test_decorator() throws {
		
		// Given
		let condition = MockGenerator.condition()
		let expectedConcern = MgoConcern(
			title: "Fracture of wrist (disorder)",
			category: "Complaint",
			clinicalStatus: "active",
			startDate: "2024-01-02",
			endDate: "2024",
			bodyLocation: "Entire wrist region, Right",
			comment: "comment"
		)
		
		// When
		let actualConcern = ConcernDecorator.create(condition)
		
		// Then
		expect(expectedConcern) == actualConcern
	}
}
