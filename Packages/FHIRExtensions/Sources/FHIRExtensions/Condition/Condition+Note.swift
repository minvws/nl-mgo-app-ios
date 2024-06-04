/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Condition {
	
	/// Is there a note for this condition?
	public var noteText: String? {
		
		return self.note?.compactMap { $0.text.value?.string }.joined(separator: ", ")
	}
}
