/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

private struct SafeAreaInsetsKey: EnvironmentKey {
	static var defaultValue: EdgeInsets = .init()
}

extension EnvironmentValues {
	var safeAreaInsets: EdgeInsets {
		get { self[SafeAreaInsetsKey.self] }
		set { self[SafeAreaInsetsKey.self] = newValue }
	}
}
