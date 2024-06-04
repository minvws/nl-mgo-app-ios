/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Patient {
	
	/// Easy way to retrieve a string for the patient's name, with a preference for the "usual" use name.
	public var humanName: String? {
		guard let names = name else {
			return nil
		}
		var useName: HumanName?
		for name in names {
			if nil == useName || .usual == name.use?.value {
				useName = name
			} else if let use = name.use, .usual == use || .official == use {
				useName = name
			}
		}
		return useName?.human
	}
	
	/// Uses the system's date formatter to format the birthdate as a short date.
	public var humanBirthDateShort: String? {
		guard let birthdate = birthDate?.value else {
			return nil
		}
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .none
		do {
			return try formatter.string(from: birthdate.asNSDate())
		} catch {
			return nil
		}
	}
	
	/// Uses the system's date formatter to format the birthdate as a medium date.
	public var humanBirthDateMedium: String? {
		guard let birthdate = birthDate?.value else {
			return nil
		}
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		do {
			return try formatter.string(from: birthdate.asNSDate())
		} catch {
			return nil
		}
	}
}

extension HumanName {
	
	/// Join the non-empty name parts into a "human-normal" string in the order prefix > given > family > suffix, joined by a space,
	/// **unless** the receiver's `text` is set, in which case the text is returned.
	public var human: String? {
		
		if let text = text?.value?.string {
			return text
		}
		
		var parts = [String]()
		if let prefix = prefix {
			parts.append(contentsOf: prefix.filter { $0.value?.string != nil }.compactMap { $0.value?.string })
		}
		if let given = given {
			parts.append(contentsOf: given.filter { $0.value?.string != nil }.compactMap { $0.value?.string })
		}
		if let family = family?.value?.string, !family.isEmpty {
			parts.append(family)
		}
		if let suffix = suffix {
			parts.append(contentsOf: suffix.filter { $0.value?.string != nil }.compactMap { $0.value?.string })
		}
		guard !parts.isEmpty else {
			return nil
		}
		return parts.joined(separator: " ")
	}
}
