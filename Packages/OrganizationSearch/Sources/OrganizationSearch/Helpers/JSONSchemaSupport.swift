/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - Helper functions for creating encoders and decoders

/// Returns a `JSONDecoder` configured with ISO 8601 date decoding.
///
/// Used consistently across the package when decoding organization data and
/// `dataServicesJSON` blobs, so that `Date`-typed fields round-trip correctly.
func newJSONDecoder() -> JSONDecoder {
	let decoder = JSONDecoder()
	if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
		decoder.dateDecodingStrategy = .iso8601
	}
	return decoder
}

/// Returns a `JSONEncoder` configured with ISO 8601 date encoding.
///
/// Used consistently across the package when encoding `dataServices` dictionaries
/// to the `dataServicesJSON` text column, so that `Date`-typed fields round-trip correctly.
func newJSONEncoder() -> JSONEncoder {
	let encoder = JSONEncoder()
	if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
		encoder.dateEncodingStrategy = .iso8601
	}
	return encoder
}
