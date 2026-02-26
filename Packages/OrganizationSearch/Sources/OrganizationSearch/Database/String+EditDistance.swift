/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension String {
	/// Returns every string within edit distance 1 of the receiver.
	///
	/// Considers four single-character operations over the lowercase a–z alphabet:
	/// - Deletion — remove one character
	/// - Substitution — replace one character with a different letter
	/// - Insertion — insert a letter at any position
	/// - Transposition — swap two adjacent characters
	///
	/// A Set deduplicates variants that different operations produce identically.
	func editDistance1Variants() -> [String] {
		let chars = Array(self)
		let length = chars.count
		let alphabet: [Character] = Array("abcdefghijklmnopqrstuvwxyz")
		var variants: Set<String> = []
		
		// Deletions
		for deletionIndex in 0..<length {
			var mutableChars = chars
			mutableChars.remove(at: deletionIndex)
			variants.insert(String(mutableChars))
		}
		
		// Substitutions
		for substitutionIndex in 0..<length {
			for ch in alphabet where ch != chars[substitutionIndex] {
				var mutableChars = chars
				mutableChars[substitutionIndex] = ch
				variants.insert(String(mutableChars))
			}
		}
		
		// Insertions
		for insertionIndex in 0...length {
			for ch in alphabet {
				var mutableChars = chars
				mutableChars.insert(ch, at: insertionIndex)
				variants.insert(String(mutableChars))
			}
		}
		
		// Transpositions
		for transpositionIndex in 0..<(length - 1) {
			var mutableChars = chars
			mutableChars.swapAt(transpositionIndex, transpositionIndex + 1)
			variants.insert(String(mutableChars))
		}
		
		return Array(variants)
	}
}
