/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing

struct EditDistanceTests {

	// MARK: - Deletions

	@Test("editDistance1Variants contains all single deletions")
	func editDistance1Variants_containsDeletion() {

		// Given
		let variants = "cat".editDistance1Variants()

		// Then — removing each character
		#expect(variants.contains("at"))  // remove 'c'
		#expect(variants.contains("ct"))  // remove 'a'
		#expect(variants.contains("ca"))  // remove 't'
	}

	// MARK: - Substitutions

	@Test("editDistance1Variants contains substitution variants")
	func editDistance1Variants_containsSubstitution() {

		// Given
		let variants = "cat".editDistance1Variants()

		// Then — replace first character with another letter
		#expect(variants.contains("bat"))
		#expect(variants.contains("hat"))
		#expect(variants.contains("rat"))
	}

	// MARK: - Insertions

	@Test("editDistance1Variants contains insertion variants")
	func editDistance1Variants_containsInsertion() {

		// Given
		let variants = "cat".editDistance1Variants()

		// Then — insert at end and at start
		#expect(variants.contains("cats"))
		#expect(variants.contains("acat"))
	}

	// MARK: - Transpositions

	@Test("editDistance1Variants contains adjacent transpositions")
	func editDistance1Variants_containsTransposition() {

		// Given
		let variants = "cat".editDistance1Variants()

		// Then — swap adjacent characters
		#expect(variants.contains("act"))  // swap c and a
		#expect(variants.contains("cta"))  // swap a and t
	}

	// MARK: - No duplicates

	@Test("editDistance1Variants contains no duplicates")
	func editDistance1Variants_noDuplicates() {

		// Given
		let variants = "cat".editDistance1Variants()

		// Then
		#expect(variants.count == Set(variants).count)
	}

	// MARK: - Single character

	@Test("editDistance1Variants on a single character produces non-empty variants")
	func editDistance1Variants_singleCharacter() {

		// Given / When
		let variants = "a".editDistance1Variants()

		// Then — deletions (empty string), substitutions, insertions
		#expect(!variants.isEmpty)
		#expect(variants.contains("")) // deletion of the only character
		#expect(variants.contains("b")) // substitution
		#expect(variants.contains("aa")) // insertion
	}
}
