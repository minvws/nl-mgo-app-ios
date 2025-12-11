/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension String {
	func capitalizingFirstLetter() -> String {
		return prefix(1).uppercased() + self.lowercased().dropFirst()
	}
}
