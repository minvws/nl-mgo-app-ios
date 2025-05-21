/*
*  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

// See https://qualitycoding.org/swift-memory-leak-detection-xctest/

extension XCTestCase {
	
	/// Track an object for memory leaks
	/// - Parameters:
	///   - instance: the object to track
	///   - file: file name
	///   - line: line number
	public func trackForMemoryLeak(
		instance: AnyObject,
		file: StaticString = #filePath,
		line: UInt = #line) {
			addTeardownBlock { [weak instance] in
				XCTAssertNil(
					instance,
					"potential memory leak on \(String(describing: instance))",
					file: file,
					line: line
				)
			}
		}
}
