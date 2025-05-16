/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
@testable import MGO

final class BinaryRepositoryTests: XCTestCase {
	
	private var fileManagerSpy: FileManagerSpy!
	private var sut: BinaryRepository!
	
	override func setUp() {
		super.setUp()
		fileManagerSpy = FileManagerSpy()
		
	}
	
	func test_init_noDirectory() {
		
		// Given
		fileManagerSpy.stubbedUrlsResult = []
		
		// When
		sut = BinaryRepository(fileManager: fileManagerSpy)
		
		// Then
		expect(self.fileManagerSpy.invokedFileExists) == false
		expect(self.fileManagerSpy.invokedCreateDirectoryAt) == false
	}
	
	func test_init_existingDirectory() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		fileManagerSpy.stubbedUrlsResult = [url]
		fileManagerSpy.stubbedFileExistsResult = true
		
		// When
		sut = BinaryRepository(fileManager: fileManagerSpy)
		
		// Then
		expect(self.fileManagerSpy.invokedFileExists) == true
		expect(self.fileManagerSpy.invokedCreateDirectoryAt) == false
	}
	
	func test_init_creatingDirectory() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		fileManagerSpy.stubbedUrlsResult = [url]
		fileManagerSpy.stubbedFileExistsResult = false
		
		// When
		sut = BinaryRepository(fileManager: fileManagerSpy)
		
		// Then
		expect(self.fileManagerSpy.invokedFileExists) == true
		expect(self.fileManagerSpy.invokedCreateDirectoryAt) == true
	}
	
	func test_store_noDocumentUrl() {
		
		// Given
		fileManagerSpy.stubbedUrlsResult = []
		sut = BinaryRepository(fileManager: fileManagerSpy)
		let binary = FHIRBinary(contentType: "application/pdf", content: "Um9vbA==")
		
		// When
		expect { try self.sut.store(binary, as: "test.pdf") }.to(throwError(BinaryRepositoryError.noUrl))
		
		// Then
		expect(self.fileManagerSpy.invokedCreateFile) == false
	}
	
	func test_store_success() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		fileManagerSpy.stubbedUrlsResult = [url]
		fileManagerSpy.stubbedCreateFileResult = true
		sut = BinaryRepository(fileManager: fileManagerSpy)
		let binary = FHIRBinary(contentType: "application/pdf", content: "Um9vbA==")
		
		// When
		let result = try self.sut.store(binary, as: "test.pdf")
		
		// Then
		expect(self.fileManagerSpy.invokedCreateFile) == true
		expect(result.absoluteString) == "https://example.com/binary/test.pdf"
	}
	
	func test_store_couldNotSaveBinary() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		fileManagerSpy.stubbedUrlsResult = [url]
		fileManagerSpy.stubbedCreateFileResult = false
		sut = BinaryRepository(fileManager: fileManagerSpy)
		let binary = FHIRBinary(contentType: "application/pdf", content: "Um9vbA==")
		
		// When
		expect { try self.sut.store(binary, as: "test.pdf") }.to(throwError(BinaryRepositoryError.couldNotSaveBinary))
		
		// Then
		expect(self.fileManagerSpy.invokedCreateFile) == true
	}
	
	func test_clear_noDocumentUrl() {
		
		// Given
		fileManagerSpy.stubbedUrlsResult = []
		sut = BinaryRepository(fileManager: fileManagerSpy)
		
		// When
		sut.clear()
		
		// Then
		expect(self.fileManagerSpy.invokedRemoveItem) == false
	}
	
	func test_clear() throws {
		
		// Given
		let url = try XCTUnwrap(URL(string: "https://example.com"))
		fileManagerSpy.stubbedUrlsResult = [url]
		sut = BinaryRepository(fileManager: fileManagerSpy)
		
		// When
		sut.clear()
		
		// Then
		expect(self.fileManagerSpy.invokedRemoveItem) == true
	}
}
