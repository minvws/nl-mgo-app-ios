/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
@testable import OrganizationSearch
import Testing

// MARK: - DateMeasurer

@Suite("DateMeasurer")
struct DateMeasurerTests {

	@Test("now() returns a Date token")
	func nowReturnsDate() {

		// Given
		let sut = DateMeasurer()

		// When
		let token = sut.now()

		// Then
		#expect(token is Date)
	}

	@Test("elapsed(since:) with a Date token returns a string containing 'seconds'")
	func elapsedWithDateReturnsSecondsString() {

		// Given
		let sut = DateMeasurer()
		let start = Date(timeIntervalSinceNow: -0.1)

		// When
		let result = sut.elapsed(since: start)

		// Then
		#expect(result.contains("seconds"))
	}

	@Test("elapsed(since:) with a wrong token type returns 'unknown'")
	func elapsedWithWrongTokenReturnsUnknown() {

		// Given
		let sut = DateMeasurer()

		// When
		let result = sut.elapsed(since: "not a date")

		// Then
		#expect(result == "unknown")
	}
}

// MARK: - ContinuousClockMeasurer

@Suite("ContinuousClockMeasurer")
struct ContinuousClockMeasurerTests {

	@Test("now() returns a ContinuousClock.Instant token")
	func nowReturnsContinuousClockInstant() {
		guard #available(iOS 16.0, *) else { return }

		// Given
		let sut = ContinuousClockMeasurer()

		// When
		let token = sut.now()

		// Then
		#expect(token is ContinuousClock.Instant)
	}

	@Test("elapsed(since:) with a ContinuousClock.Instant token returns a non-'unknown' string")
	func elapsedWithInstantReturnsString() {
		guard #available(iOS 16.0, *) else { return }

		// Given
		let sut = ContinuousClockMeasurer()
		let start = sut.now()

		// When
		let result = sut.elapsed(since: start)

		// Then
		#expect(result != "unknown")
		#expect(!result.isEmpty)
	}

	@Test("elapsed(since:) with a wrong token type returns 'unknown'")
	func elapsedWithWrongTokenReturnsUnknown() {
		guard #available(iOS 16.0, *) else { return }

		// Given
		let sut = ContinuousClockMeasurer()

		// When
		let result = sut.elapsed(since: "not an instant")

		// Then
		#expect(result == "unknown")
	}
}

// MARK: - makeMeasurableClock

@Suite("makeMeasurableClock")
struct MakeMeasurableClockTests {

	@Test("returns ContinuousClockMeasurer on iOS 16+")
	func returnsContinuousClockMeasurerOnIOS16() {
		guard #available(iOS 16.0, *) else { return }

		// When
		let clock = makeMeasurableClock()

		// Then
		#expect(clock is ContinuousClockMeasurer)
	}

	@Test("returns DateMeasurer on iOS 15")
	func returnsDateMeasurerOnIOS15() {
		guard !ProcessInfo.processInfo.isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 16, minorVersion: 0, patchVersion: 0)) else { return }

		// When
		let clock = makeMeasurableClock()

		// Then
		#expect(clock is DateMeasurer)
	}

	@Test("returned clock produces a non-'unknown' elapsed string")
	func returnedClockProducesElapsedString() {

		// Given
		let clock = makeMeasurableClock()
		let start = clock.now()

		// When
		let result = clock.elapsed(since: start)

		// Then
		#expect(result != "unknown")
		#expect(!result.isEmpty)
	}
}
