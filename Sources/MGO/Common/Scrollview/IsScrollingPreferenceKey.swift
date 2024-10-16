/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct IsScrollingPreferenceKey: PreferenceKey {
	static var defaultValue: [Bool] = []
	
	static func reduce(value: inout [Bool], nextValue: () -> [Bool]) {
		value.append(contentsOf: nextValue())
	}
}
