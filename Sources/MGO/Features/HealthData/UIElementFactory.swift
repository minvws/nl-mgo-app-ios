/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

class UIElementFactory {
	
	/// Cast a UIElement unto a UIElementProtocol object
	/// - Parameter entry: the UIElement to cast
	/// - Returns: the optional UIElementProtocol
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

public protocol UIElementProtocol {
	var elementType: String { get }
	var label: String { get }
}

extension DownloadBinary: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}
extension DownloadLink: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}
extension MultipleGroupedValues: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}
extension MultipleValues: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}
extension ReferenceLink: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}
extension ReferenceValue: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}
extension SingleValue: UIElementProtocol {
	public var elementType: String {
		return type.rawValue
	}
}

public extension HealthUIGroup {
	
	/// An array of casted UIElements unto the protocol
	var uiElements: [UIElementProtocol] {
		return children.compactMap { UIElementFactory().cast($0) }
	}
}
