/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import HCIMCore
import Foundation
import Testing

struct FHIRDateStringTests {
	
	/// Minimal conforming type so the tests exercise `FHIRDateParser` through the public protocol surface.
	private struct Wrapper: FHIRDateString {
		let value: String
	}
	
	private static let utc = TimeZone(secondsFromGMT: 0)!
	private static let amsterdam = TimeZone(identifier: "Europe/Amsterdam")!
	private static let calendar = Calendar(identifier: .gregorian)
	
	// MARK: - Full ISO8601
	
	@Test("Parses full ISO8601 with fractional seconds")
	func parsesIso8601WithFractionalSeconds() throws {
		
		// Given
		let date = try #require(Wrapper(value: "2026-05-06T13:45:30.123Z").date)
		
		// When
		let components = date.utcComponents()
		
		// Then
		#expect(components.year == 2026)
		#expect(components.month == 5)
		#expect(components.day == 6)
		#expect(components.hour == 13)
		#expect(components.minute == 45)
		#expect(components.second == 30)
	}
	
	@Test("Parses full ISO8601 without fractional seconds")
	func parsesIso8601WithoutFractionalSeconds() throws {
		
		// Given
		let date = try #require(Wrapper(value: "2026-05-06T13:45:30Z").date)
		
		// When
		let components = date.utcComponents()
		
		// Then
		#expect(components.year == 2026)
		#expect(components.month == 5)
		#expect(components.day == 6)
		#expect(components.hour == 13)
		#expect(components.minute == 45)
		#expect(components.second == 30)
	}
	
	@Test("Parses ISO8601 with a positive timezone offset")
	func parsesIso8601WithPositiveTimezoneOffset() throws {
		// 13:45 in +02:00 is 11:45 UTC.
		
		// Given
		let date = try #require(Wrapper(value: "2026-05-06T13:45:30+02:00").date)
		
		// When
		let components = date.utcComponents()
		
		// Then
		#expect(components.year == 2026)
		#expect(components.month == 5)
		#expect(components.day == 6)
		#expect(components.hour == 11)
		#expect(components.minute == 45)
		#expect(components.second == 30)
	}
	
	@Test("Parses ISO8601 with a negative timezone offset that crosses midnight")
	func parsesIso8601WithNegativeTimezoneOffset() throws {
		// 23:00 on 2026-05-06 in -05:00 is 04:00 UTC on 2026-05-07.
		
		// Given
		let date = try #require(Wrapper(value: "2026-05-06T23:00:00-05:00").date)
		
		// When
		let components = date.utcComponents()
		
		// Then
		#expect(components.year == 2026)
		#expect(components.month == 5)
		#expect(components.day == 7)
		#expect(components.hour == 4)
		#expect(components.minute == 0)
	}
	
	// MARK: - Partial precision
	
	@Test("Parses partial-precision year-month-day")
	func parsesYearMonthDay() throws {
		
		// Given
		let date = try #require(Wrapper(value: "2026-05-06").date)
		
		// When (Partial dates anchor at midnight Europe/Amsterdam).
		let components = Self.calendar.dateComponents(
			in: Self.amsterdam,
			from: date
		)
		
		// Then
		#expect(components.year == 2026)
		#expect(components.month == 5)
		#expect(components.day == 6)
		#expect(components.hour == 0)
		#expect(components.minute == 0)
		#expect(components.second == 0)
	}
	
	@Test("Parses partial-precision year-month, defaulting day to the 1st")
	func parsesYearMonth() throws {
		
		// Given
		let date = try #require(Wrapper(value: "2026-05").date)
		
		// When
		let components = Self.calendar.dateComponents(
			in: Self.amsterdam,
			from: date
		)
		
		// Then
		#expect(components.year == 2026)
		#expect(components.month == 5)
		#expect(components.day == 1)
	}
	
	@Test("Parses partial-precision year, defaulting to January 1st")
	func parsesYear() throws {
		
		// Given
		let date = try #require(Wrapper(value: "2026").date)
		
		// When
		let components = Self.calendar.dateComponents(
			in: Self.amsterdam,
			from: date
		)
		
		// Then
		#expect(components.year == 2026)
		#expect(components.month == 1)
		#expect(components.day == 1)
	}
	
	// MARK: - Format precedence
	
	@Test("Prefers higher precision when multiple formats could match")
	func prefersHigherPrecisionWhenAmbiguous() throws {
		// "2026-05-06" must be parsed by the day formatter, not silently truncated to year/month.
		
		// Given
		let date = try #require(Wrapper(value: "2026-05-06").date)
		
		// When
		let components = Self.calendar.dateComponents(in: Self.amsterdam, from: date)
		
		// Then
		#expect(components.day == 6)
		#expect(components.month == 5)
	}
	
	// MARK: - Invalid inputs
	
	@Test("Returns nil for malformed or out-of-range inputs", arguments: [
		"",
		"   ",
		"not a date",
		"2026/05/06",
		"06-05-2026",
		"2026-13-01",       // month out of range
		"2026-05-32",       // day out of range
		"2026-05-06T25:00:00Z", // hour out of range
		"T13:45:30Z",       // missing date part
		"2026-05-06T13:45"  // incomplete time
	])
	func returnsNilForInvalidInputs(_ input: String) {
		#expect(Wrapper(value: input).date == nil)
	}
}

private extension Date {
	
	/// Decompose into UTC `DateComponents` so assertions don't drift with the test runner's locale.
	func utcComponents() -> DateComponents {
		Calendar(identifier: .gregorian).dateComponents(
			in: TimeZone(secondsFromGMT: 0)!,
			from: self
		)
	}
}
