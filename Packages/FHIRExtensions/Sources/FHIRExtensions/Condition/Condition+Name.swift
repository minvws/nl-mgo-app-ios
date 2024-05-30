/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Condition {
	
	/// What is the name of this condition?
	public var name: String? {
		
		return self.code?.coding?.compactMap { $0.display?.value?.string }.joined()
	}
}
