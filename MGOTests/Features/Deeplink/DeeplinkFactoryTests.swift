/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
@testable import MGO

final class DeepLinkFactoryTests: XCTestCase {
	
	private var sut: DeepLinkFactory!
	
	override func setUp() {
		
		super.setUp()
		sut = DeepLinkFactory()
	}
	
	func test_create_validDeeplink() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "mgo-dev://app/login?userinfo=TEST"))
		
		// When
		let result = DeepLinkFactory().create(url)
		
		// Then
		expect(result) == DeepLink.digidCallback(userinfo: "TEST")
	}
	
	func test_create_invalidDeeplink() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "mgo-dev://app/login")) // No userinfo

		// When
		let result = DeepLinkFactory().create(url)
		
		// Then
		expect(result) == nil
	}
}
