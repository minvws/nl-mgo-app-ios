/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

// See https://stackoverflow.com/a/63951611/443270
public extension LocalizedStringKey {
	var stringKey: String {
		Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String ?? ""
	}
}
