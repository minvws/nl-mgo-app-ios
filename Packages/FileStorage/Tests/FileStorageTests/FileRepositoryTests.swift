/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import FileStorage
import Testing

@MainActor
final class FileRepositoryTests {
	
	private var sut: FileRepository<String>!
	private let item = "Item 1"
	
	init () {
		sut = FileRepository<String>(fileName: "fileRepository.json")
		sut.wipePersistedData()
	}
	
	deinit {
		sut.wipePersistedData()
	}
	
	@Test func storeToDisk() throws {
		
		// Given
		
		// When
		try sut.store(item)
		let list = try sut.read()
		
		// Then
		#expect(list.count == 1)
		#expect(list.first == item)
		#expect(sut.items.count == 1)
		#expect(sut.items == list)
	}
	
	@Test func storeToDiskTwice_savesJustOne() throws {
		
		// Given
		
		// When
		try sut.store(item)
		try sut.store(item)
		let list = try sut.read()
		
		// Then
		#expect(list.count == 1)
		#expect(list.first == item)
		#expect(sut.items.count == 1)
		#expect(sut.items == list)
	}
	
	@Test func storeAndRemoveToDisk() throws {
		
		// Given
		try sut.store(item)
		
		// When
		try sut.remove(item)
		let list = try sut.read()
		
		// Then
		#expect(list.isEmpty)
		#expect(sut.items.isEmpty)
	}
	
	@Test func set() throws {
		
		// Given
		
		// When
		try sut.set([item])
		
		// Then
		let list = try sut.read()
		#expect(list.count == 1)
		#expect(list.first == item)
	}
	
	@Test func wipePersistentData() throws {
		
		// Given
		
		try sut.store(item)
		
		// When
		sut.wipePersistedData()
		let list = try sut.read()
		
		// Then
		#expect(list.isEmpty)
		#expect(sut.items.isEmpty)
	}
}
