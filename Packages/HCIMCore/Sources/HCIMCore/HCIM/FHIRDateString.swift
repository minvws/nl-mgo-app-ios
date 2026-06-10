/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Shared parsing for the generated FHIR primitive wrappers that carry a date/time string.
/// FHIR `dateTime` permits partial precision (`YYYY`, `YYYY-MM`, `YYYY-MM-DD`) as well as
/// full ISO8601 timestamps with timezone offset. `instant` is always full ISO8601.
public protocol FHIRDateString {
	var value: String { get }
}

public extension FHIRDateString {
	var date: Date? { FHIRDateParser.parse(value) }
}

extension MgoDateTime: FHIRDateString {}
extension MgoInstant: FHIRDateString {}

private enum FHIRDateParser {

	/// Parse a FHIR date / dateTime / instant string into a `Date`.
	/// Tries the supported formats in order of decreasing precision and returns the first match.
	/// - Parameter string: the raw string from a FHIR primitive wrapper's `value` field
	/// - Returns: a `Date` if any format matched, otherwise `nil`
	static func parse(_ string: String) -> Date? {
		for parser in parsers {
			if let date = parser(string) { return date }
		}
		return nil
	}

	/// Ordered list of parse attempts, most precise first so a full ISO8601 timestamp
	/// is preferred over a partial date when both could technically match.
	/// Partial-precision parsers roundtrip-validate the result because `DateFormatter`
	/// accepts loose inputs (e.g. `"2026/05/06"` is silently parsed against `"yyyy-MM-dd"`).
	private static let parsers: [@Sendable (String) -> Date?] = [
		{ isoWithFractional.date(from: $0) },
		{ iso.date(from: $0) },
		{ strict(day, $0) },
		{ strict(month, $0) },
		{ strict(year, $0) }
	]

	/// Parse `string` with `formatter` and only accept the result if formatting it back
	/// reproduces the original input — protects against `DateFormatter`'s loose behavior
	/// around separators, prefix matches, and out-of-range components.
	private static func strict(_ formatter: DateFormatter, _ string: String) -> Date? {
		guard let date = formatter.date(from: string), formatter.string(from: date) == string else {
			return nil
		}
		return date
	}

	/// Full ISO8601 with fractional seconds (e.g. `2026-05-06T13:45:30.123Z`).
	/// `ISO8601DateFormatter` is thread-safe for parsing but not yet marked `Sendable`.
	nonisolated(unsafe) private static let isoWithFractional: ISO8601DateFormatter = {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		return formatter
	}()

	/// Full ISO8601 without fractional seconds (e.g. `2026-05-06T13:45:30Z`).
	nonisolated(unsafe) private static let iso: ISO8601DateFormatter = {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime]
		return formatter
	}()

	/// FHIR partial-precision dates: day, month and year only.
	private static let day = fhir("yyyy-MM-dd")
	private static let month = fhir("yyyy-MM")
	private static let year = fhir("yyyy")

	/// Build a `DateFormatter` configured for Dutch locale and the Europe/Amsterdam timezone.
	/// - Parameter format: the `dateFormat` pattern to apply
	/// - Returns: a configured formatter, intended to be cached as a static constant
	private static func fhir(_ format: String) -> DateFormatter {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "nl")
		formatter.timeZone = TimeZone(identifier: "Europe/Amsterdam")
		formatter.dateFormat = format
		formatter.isLenient = false
		return formatter
	}
}
