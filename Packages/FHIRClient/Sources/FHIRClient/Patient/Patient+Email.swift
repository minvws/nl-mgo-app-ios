/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Patient {
	
	/// The the primary email address of the patient
	/// - Returns: optional email address
	public func getEmail() -> String? {
		
		// Only emails
		let emailContactPoints: [ContactPoint] = self.telecom?
			.compactMap { $0 }
			.filter { $0.system == .email } ?? []
		
		// Only undefined use, or home, work, temp usage
		let filteredEmails = emailContactPoints
			.filter { $0.use != .old }
			.filter { $0.use != .mobile }
		
		// Sort on use, nil, home, work, temp
		let sortedEmails = filteredEmails
			.sorted { lhs, rhs in
				lhs < rhs
			}
	
		return sortedEmails.first?.value?.string
	}
}
