/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Condition {

	/// When did this condition start?
	public var startDate: String? {
		
		var date: Date?
		do {
/*
 case period(Period)
 case dateTime(FHIRPrimitive<DateTime>)
 case age(Age)
 case range(Range)
 case string(FHIRPrimitive<FHIRString>)
 */
			
			if case .age(let age) = self.onset {
				if let decimal = age.value?.value?.decimal {
					return "\(decimal)"
				}
			}
			if case .dateTime(let dateTime) = self.onset {
				date = try dateTime.value?.asNSDate()
			}
			if case .period(let period) = self.onset {
				date = try period.start?.value?.date.asNSDate()
			}
			if case .string(let string) = self.onset {
				return string.value?.string
			}
			if case .range(let range) = self.onset {
				#warning("Todo: range of condition onset")
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
	
	/// When did this condition end?
	public var endDate: String? {
		
		var date: Date?
		do {
/*
 case age(Age)
 case boolean(FHIRPrimitive<FHIRBool>)
 case dateTime(FHIRPrimitive<DateTime>)
 case period(Period)
 case range(Range)
 case string(FHIRPrimitive<FHIRString>)
 */
			
			if case .age(let age) = self.abatement {
				if let decimal = age.value?.value?.decimal {
					return "\(decimal)"
				}
			}
			if case .boolean(let boolean) = self.abatement {
				#warning("Todo: boolean of condition abatement")
			}
			if case .dateTime(let dateTime) = self.abatement {
				date = try dateTime.value?.asNSDate()
			}
			if case .period(let period) = self.abatement {
				date = try period.start?.value?.date.asNSDate()
			}
			if case .string(let string) = self.abatement {
				return string.value?.string
			}
			if case .range(let range) = self.abatement {
				#warning("Todo: range of condition abatement")
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
