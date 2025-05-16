/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import CommonCrypto

public extension Data {
	
	/// Get the SHA256 hash of data
	var sha256: Data {
		
		var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
		
		withUnsafeBytes {
			_ = CC_SHA256($0.baseAddress, CC_LONG(count), &hash)
		}
		
		return Data(hash)
	}
}
