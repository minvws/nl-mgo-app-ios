/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import PdfExport

/// UIElement → PDF mapping helpers.
///
/// This file contains concrete implementations of `getPdfMapping()` for the
/// various UI element types. Each implementation converts the element's label
/// and displayable value(s) into a `PdfSubTablePair` that can be consumed by the
/// PDF export pipeline.
///
/// Return semantics
/// - Returns `nil` when there is no meaningful value to render.
/// - Returns a non-empty `PdfSubTablePair` when at least one displayable value exists.

extension SingleValue {
	
	/// PDF mapping for a single value element.
	/// Builds a `PdfSubTablePair` from the element's `label` and the value's `display`.
	/// - Returns: `nil` when `value?.display` is missing.
	public func getPdfMapping() -> PdfSubTablePair? {
		
		guard let display = value?.display else { return nil }
		return PdfSubTablePair(key: label, value: display)
	}
}

extension MultipleValues {
	
	/// PDF mapping for a list of values; values are joined with newlines.
	/// Joins all available displays with newlines and maps them under `label`.
	/// - Returns: `nil` when there are no values or all displays are empty.
	public func getPdfMapping() -> PdfSubTablePair? {
		
		guard let values = value else { return nil }
		let joined = values.compactMap(\.display).joined(separator: "\n")
		return joined.isEmpty ? nil : PdfSubTablePair(key: label, value: joined)
	}
}

extension MultipleGroupedValues {
	
	/// PDF mapping for grouped lists of values; flattens groups and joins with newlines.
	/// Flattens grouped values, joins their displays with newlines, and maps under `label`.
	/// - Returns: `nil` when there are no values or all displays are empty.
	public func getPdfMapping() -> PdfSubTablePair? {
		
		guard let values = value else { return nil }
		let joined = values.flatMap { $0 }.compactMap(\.display).joined(separator: "\n")
		return joined.isEmpty ? nil : PdfSubTablePair(key: label, value: joined)
	}
}

extension ReferenceValue {
	
	/// PDF mapping for a reference value element.
	/// Builds a `PdfSubTablePair` from the element's `label` and the value's `display`.
	public func getPdfMapping() -> PdfSubTablePair? {
		
		guard let display else { return nil }
		return PdfSubTablePair(key: label, value: display)
	}
}

extension ReferenceLink {

	/// PDF mapping for a reference link element.
	/// Builds a `PdfSubTablePair` from the element's `label` as the value, and a empty string as key.
	public func getPdfMapping() -> PdfSubTablePair? {
		
		return PdfSubTablePair(key: "", value: label)
	}
}

extension DownloadLink {
	/// PDF mapping for a download link: full-width row with icon and label in blue.
	public func getPdfMapping() -> PdfSubTablePair? {
		return PdfSubTablePair(key: "", value: label, style: .download)
	}
}

extension DownloadBinary {
	/// PDF mapping for a downloadable binary: full-width row with icon and label in blue.
	public func getPdfMapping() -> PdfSubTablePair? {
		return PdfSubTablePair(key: "", value: label, style: .download)
	}
}
