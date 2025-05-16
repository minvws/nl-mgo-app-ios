/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import CommonCrypto

public extension String {
	
	/// Get the SHA256 hash of a string
	var sha256: String {
		
		let str = cString(using: .utf8)
		let strLen = CUnsignedInt(lengthOfBytes(using: .utf8))
		let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
		let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
		
		CC_SHA256(str, strLen, result)
		
		let hash = NSMutableString()
		
		for index in 0 ..< digestLen {
			hash.appendFormat("%02x", result[index])
		}
		
		result.deallocate()
		
		return String(format: hash as String)
	}
}
