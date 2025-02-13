/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class R4NlCoreNameInformationFactory {
	
	public func cast(_ nameElement: NameElement) -> R4NlCoreNameInformationProtocol? {
		
		switch nameElement.use {
			case .usual:
				return try? R4NlCoreNameInformation(data: nameElement.jsonData())
			case .official:
				return try? R4NlCoreNameInformationGiven(data: nameElement.jsonData())
		}
	}
}

public protocol R4NlCoreNameInformationProtocol {
	var elementType: String { get }
}

extension R4NlCoreNameInformation: R4NlCoreNameInformationProtocol {
	public var elementType: String {
		return use.rawValue
	}
}

extension R4NlCoreNameInformationGiven: R4NlCoreNameInformationProtocol {
	public var elementType: String {
		return use.rawValue
	}
}

public extension R4NlCoreHealthProfessionalPractitioner {
	
	/// An array of casted nameElements unto the protocol
	var nameElements: [R4NlCoreNameInformationProtocol]? {
		return name?.compactMap { R4NlCoreNameInformationFactory().cast($0) }
	}
}
