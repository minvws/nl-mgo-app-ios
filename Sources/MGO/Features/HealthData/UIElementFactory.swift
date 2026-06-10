/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import PdfExport

/// A small factory responsible for converting raw `UIElement` models
/// into strongly-typed objects that conform to `UIElementProtocol`.
///
/// This type centralizes the mapping from a `UIElementType` (the `entry.type`)
/// to its concrete implementation, using the element's JSON payload (`entry.jsonData()`).
///
/// Responsibilities
/// - Decodes the JSON for a given `UIElement` into its matching concrete type.
/// - Returns a `UIElementProtocol` so callers can treat different element kinds uniformly.
/// - Fails gracefully (returns `nil`) when decoding fails or an element can't be mapped.
///
/// Usage
/// ```swift
/// let factory = UIElementFactory()
/// if let viewModel = factory.cast(element) {
///     // Use shared protocol surface
///     Log(viewModel.elementType)
/// }
/// ```
///
/// Notes
/// - This factory performs a best-effort cast: it uses `try?` during decoding and
///   returns `nil` on failure. Consider logging failures at the call site if needed.
/// - The mapping is defined in the `switch` over `entry.type`. When new element types
///   are introduced, add their case there and (optionally) extend the concrete type to
///   conform to `UIElementProtocol`.
class UIElementFactory {
	
	/// Attempts to decode a concrete UI element from the provided `UIElement`.
	///
	/// The method inspects `entry.type` and tries to initialize the corresponding
	/// concrete type using `entry.jsonData()`. If decoding succeeds, the instance is
	/// returned as `UIElementProtocol`; otherwise, `nil` is returned.
	///
	/// - Parameter entry: The raw `UIElement` to decode.
	/// - Returns: A concrete element conforming to `UIElementProtocol`, or `nil` if decoding fails.
	/// - Important: This method is intentionally non-throwing and uses `try?` to avoid
	///   propagating decoding errors. If you need diagnostics, add logging at the call site.
	func cast(_ entry: UIElement) -> UIElementProtocol? {
		switch entry.type {
			case .downloadBinary:
				return try? DownloadBinary(data: entry.jsonData())
			case .downloadLink:
				return try? DownloadLink(data: entry.jsonData())
			case .multipleGroupedValues:
				return try? MultipleGroupedValues(data: entry.jsonData())
			case .multipleValues:
				return try? MultipleValues(data: entry.jsonData())
			case .referenceLink:
				return try? ReferenceLink(data: entry.jsonData())
			case .referenceValue:
				return try? ReferenceValue(data: entry.jsonData())
			case .singleValue:
				return try? SingleValue(data: entry.jsonData())
		}
	}
}

/// A lightweight interface that all concrete UI elements conform to.
///
/// Conformers provide a common surface area used by rendering and export layers
/// (e.g., PDF export). The `elementType` typically mirrors the server-provided
/// `UIElementType` raw value.
public protocol UIElementProtocol {

	var elementType: String { get }

	var label: String { get }

	func getPdfMapping() -> PdfSubTablePair?

	/// Whether this element renders edge-to-edge, breaking out of its section
	/// card. Defaults to `false`; full-width elements (e.g. DICOM imagery)
	/// override to `true`.
	var prefersFullWidth: Bool { get }
}

/// Default behaviors for `UIElementProtocol`.
///
/// Provides a no-op implementation for `getPdfMapping()` so conforming types
/// can opt-in to PDF export selectively. Types that contribute content to the
/// PDF should override this default and return the appropriate `PdfSubTablePair` data.
extension UIElementProtocol {
	public func getPdfMapping() -> PdfSubTablePair? { nil }

	public var prefersFullWidth: Bool { false }
}

/// Conformance to `UIElementProtocol` for DownloadBinary.
extension DownloadBinary: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}

/// Conformance to `UIElementProtocol` for DownloadLink.
extension DownloadLink: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}

/// Conformance to `UIElementProtocol` for MultipleGroupedValues.
extension MultipleGroupedValues: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}

/// Conformance to `UIElementProtocol` for MultipleValues.
extension MultipleValues: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}

/// Conformance to `UIElementProtocol` for ReferenceLink.
extension ReferenceLink: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}

/// Conformance to `UIElementProtocol` for ReferenceValue.
extension ReferenceValue: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}

/// Conformance to `UIElementProtocol` for SingleValue.
extension SingleValue: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}

public extension HealthUIGroup {
	
	/// Lazily casts child `UIElement` models to their concrete types using `UIElementFactory`.
	///
	/// Elements that fail to decode are omitted via `compactMap`.
	var uiElements: [UIElementProtocol] {
		return children.compactMap { UIElementFactory().cast($0) }
	}
}
