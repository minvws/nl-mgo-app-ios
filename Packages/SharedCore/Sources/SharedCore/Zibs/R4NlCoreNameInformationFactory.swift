/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class R4NlCoreNameInformationFactory {
	
	/// Cast a NameElement unto a R4NlCoreNameInformationProtocol object
	/// - Parameter nameElement: the nameElement to cast
	/// - Returns: an optional R4NlCoreNameInformationProtocol object
	public func cast(_ nameElement: NameElement) -> R4NlCoreNameInformationProtocol? {
		
		switch nameElement.use {
			case .usual:
				return try? R4NlCoreNameInformationGiven(data: nameElement.jsonData())
			case .official:
				return try? R4NlCoreNameInformation(data: nameElement.jsonData())
		}
	}
}

public protocol R4NlCoreNameInformationProtocol {
	/* empty protocol */
}

extension R4NlCoreNameInformation: R4NlCoreNameInformationProtocol {
	/* conforms to empty protocol */
}

extension R4NlCoreNameInformationGiven: R4NlCoreNameInformationProtocol {
	/* conforms to empty protocol */
}

public extension R4NlCoreHealthProfessionalPractitioner {
	
	/// An array of casted nameElements unto the protocol
	var nameElements: [R4NlCoreNameInformationProtocol]? {
		return name?.compactMap { R4NlCoreNameInformationFactory().cast($0) }
	}
}
