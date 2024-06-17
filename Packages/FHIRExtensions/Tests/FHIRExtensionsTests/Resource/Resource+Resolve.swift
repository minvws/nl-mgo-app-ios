/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import FHIRExtensions

final class ResourceResolveTests: XCTestCase {

	func test_resource_resolve_1() throws {
		
		// Given
		let json = try getResource("stu3-bundle-observation-specimen")
		let bundle = try Resource.fromJSON(json, type: ModelsSTU3.Bundle.self)
		let observations: [Observation] = bundle.entry?.compactMap {
			$0.resource?.get(if: ModelsSTU3.Observation.self)
		} ?? []
		let observation = try XCTUnwrap(observations.first)
		
		// When
		let specimen: Specimen? = observation.resolve(observation.specimen, from: bundle)
		
		// Then
		expect(specimen?.name) == "Bloed (substantie)"
	}
}
