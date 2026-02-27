/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// A type that provides the current instant and formats durations between two instants.
///
/// Inject a `MeasurableClock` into `JSContextManager` or `DatabaseActor` to control timing behaviour in tests.
/// The work being timed stays in the caller; only the timestamp bookkeeping is delegated here.
protocol MeasurableClock: Sendable {
	
	/// Returns an opaque "now" token.
	func now() -> any Sendable
	
	/// Returns a human-readable string representing the elapsed time between `start` (from a previous
	/// call to `now()`) and the current moment.
	func elapsed(since start: any Sendable) -> String
}

// MARK: - ContinuousClockMeasurer

/// `MeasurableClock` backed by `ContinuousClock.Instant` (iOS 16+).
@available(iOS 16.0, *)
struct ContinuousClockMeasurer: MeasurableClock {
	
	func now() -> any Sendable {
		ContinuousClock.now
	}
	
	func elapsed(since start: any Sendable) -> String {
		guard let start = start as? ContinuousClock.Instant else { return "unknown" }
		let duration = ContinuousClock.now - start
		return "\(duration)"
	}
}

// MARK: - DateMeasurer

/// `MeasurableClock` backed by `Date` subtraction (iOS 15 fallback).
struct DateMeasurer: MeasurableClock {
	
	func now() -> any Sendable {
		Date()
	}
	
	func elapsed(since start: any Sendable) -> String {
		guard let start = start as? Date else { return "unknown" }
		let duration = Date().timeIntervalSince(start)
		return "\(duration) seconds"
	}
}

// MARK: - Factory

/// Returns the best available `MeasurableClock` for the current OS.
func makeMeasurableClock() -> any MeasurableClock {
	if #available(iOS 16.0, *) {
		return ContinuousClockMeasurer()
	}
	return DateMeasurer()
}
