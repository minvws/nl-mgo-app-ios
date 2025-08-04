/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// For recording calls to an observer during tests
class ObserverCallbackRecorder<T> {
	
	var values: [T] = []
	
	func recordEvents(_ value: T) {
		values += [value]
	}
}
