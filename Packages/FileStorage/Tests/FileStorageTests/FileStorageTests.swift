/*
*  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

@testable import FileStorage
import MGOTest

class FileStorageTests: XCTestCase {
	
	private var sut: FileStorage!
	
	override func setUp() {
		super.setUp()
		
		sut = FileStorage()
	}
	
	func test_documentsURL() {
		
		// Given
		
		// When
		let url: URL? = sut.documentsURL
		
		// Then
		expect(url) != nil
		expect(url?.absoluteString).to(endWith("/data/Documents/"))
	}
	
	func test_store_exists_read_remove() throws {
		
		// Given
		let file = try getResource("test")
		let fileName = "test_store.md"
		
		// When
		try sut.store(file, as: fileName)
		
		// Read
		expect(self.sut.fileExists(fileName)).toEventually(beTrue())
		let readFile = sut.read(fileName: fileName)
		expect(file) == readFile
		
		// Remove
		sut.remove(fileName)
		expect(self.sut.fileExists(fileName)).toEventually(beFalse())
		expect(self.sut.read(fileName: fileName)) == nil
	}
}
