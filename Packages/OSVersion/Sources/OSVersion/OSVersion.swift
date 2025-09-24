/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public enum iOSVersion: String, Codable { // swiftlint:disable:this type_name
	case v15
	case v16
	case v17
	case v18
	case v26
}

public enum OSVersion: Codable {
	
	case iOS(iOSVersion)
}
