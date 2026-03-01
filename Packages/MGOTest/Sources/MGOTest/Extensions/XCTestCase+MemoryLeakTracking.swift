/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		line: UInt = #line
	) {
		// WeakBox wraps the weak reference in an @unchecked Sendable class so it can
		// be safely captured by the @Sendable addTeardownBlock closure in Swift 6.
		final class WeakBox: @unchecked Sendable {
			weak var value: AnyObject?

			init(_ value: AnyObject) { self.value = value }
		}
		let box = WeakBox(instance)
		addTeardownBlock {
			XCTAssertFalse(
				box.value != nil,
				"potential memory leak on \(String(describing: box.value))",
				file: file,
				line: line
			)
		}
	}
}
