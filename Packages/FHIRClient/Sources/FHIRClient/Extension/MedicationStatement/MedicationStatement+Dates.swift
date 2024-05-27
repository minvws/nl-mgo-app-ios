/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension MedicationStatement {
	
	/// When should we start taking this medication?
	public var startDate: String? {
		
		var date: Date?
		do {
			if case .period(let period) = self.effective {
				date = try  period.start?.value?.date.asNSDate()
			}
			if case .dateTime(let dateTime) = self.effective {
				date = try dateTime.value?.asNSDate()
			}
			
			guard let date else { return nil }
			
			let formatter = DateFormatter()
			formatter.dateStyle = .long
			formatter.timeStyle = .none
			
			return formatter.string(from: date)
		} catch {
			return nil
		}
	}
	
	/// When should we stop taking this medication?
	public var endDate: String? {
		
		var date: Date?
		do {
			if case .period(let period) = self.effective {
				date = try  period.end?.value?.date.asNSDate()
			}
			
			guard let date else { return nil }
			
			let formatter = DateFormatter()
			formatter.dateStyle = .long
			formatter.timeStyle = .none
			
			return formatter.string(from: date)
		} catch {
			return nil
		}
	}
}
