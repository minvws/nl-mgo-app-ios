/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public var isiPhoneSE: Bool {
	Device.current == .iPhoneSE || Device.current == .simulator(.iPhoneSE)
}

public var isIOS15: Bool {
	if #unavailable(iOS 16) {
		return true
	}
	return false
}

public var belowIOS18: Bool {
	if #available(iOS 18, *) {
		return false
	}
	return true
}

public var isIOS16OrOlder: Bool {
	if #unavailable(iOS 17) {
		return true
	}
	return false

}
