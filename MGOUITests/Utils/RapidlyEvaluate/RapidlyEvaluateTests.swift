/*
 *  Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import CoreFoundation
import MGOTest

class RapidlyEvaluateTests: XCTestCase {
	
	func testPassingImmediately() throws {
		
		let result = rapidlyEvaluate {
			true
		}
		
		expect(result) == true
	}
	
	func testPassingEventually() throws {
		
		let until = Date(timeIntervalSinceNow: 1)
		
		let result = rapidlyEvaluate {
			until < Date()
		}
		expect(result) == true
	}
	
	func testFailingWithTimeout() throws {
		
		let until = Date(timeIntervalSinceNow: 2)
		
		let result = rapidlyEvaluate(timeout: 1) {
			until < Date()
		}
		expect(result) == false
	}
}
