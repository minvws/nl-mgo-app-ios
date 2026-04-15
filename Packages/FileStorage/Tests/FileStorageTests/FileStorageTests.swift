/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import FileStorage
import Testing

struct FileStorageTests {

	@Test("fileUrl returns a URL pointing to the documents directory")
	func fileUrl() {

		// Given
		let sut = FileStorage()

		// When
		let url = sut.fileUrl("test.txt")

		// Then
		#expect(url != nil)
		#expect(url?.absoluteString.hasSuffix("/data/Documents/test.txt") == true)
	}

	@Test("fileUrl with sub directory returns a URL pointing to the sub directory")
	func fileUrl_withSubDirectory() {

		// Given
		let sut = FileStorage(subDirectory: "filestorage")

		// When
		let url = sut.fileUrl("test.txt")

		// Then
		#expect(url != nil)
		#expect(url?.absoluteString.hasSuffix("/data/Documents/filestorage/test.txt") == true)
	}

	@Test("stored file can be read back and is gone after removal")
	func storeExistsReadRemove() throws {

		// Given
		let sut = FileStorage()
		let file = try getResource("test")
		let fileName = "test_store.md"

		// Store
		try sut.store(file, as: fileName)

		// Read
		#expect(sut.fileExists(fileName))
		let readFile = sut.read(fileName: fileName)
		#expect(file == readFile)

		// Remove
		sut.remove(fileName)
		#expect(!sut.fileExists(fileName))
		#expect(sut.read(fileName: fileName) == nil)
	}
}
