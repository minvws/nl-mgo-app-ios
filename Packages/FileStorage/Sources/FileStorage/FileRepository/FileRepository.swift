/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug
import Observatory

public enum FileRepositoryReason {
	case added
	case removed
	case changed
}

public protocol FileRepositoryProtocol{
	
	associatedtype Item: Codable
	
	/// The list of stored objects
	var items: [Item] { get }
	
	/// Observatory for changes
	var observatory: Observatory<(Item?, FileRepositoryReason)> { get }
	
	/// Add an item to the storage
	/// - Parameter item: the item to store
	func store(_ item: Item) throws
	
	/// Delete an item from storage
	/// - Parameter item: the item to be removed
	func remove(_ item: Item) throws
	
	/// set the list of items
	/// - Parameter new: the item to be stored
	func set(_ new: [Item]) throws
	
	/// Remove all the stored items
	func wipePersistedData()
}

public class FileRepository<Item: Codable & Equatable>: FileRepositoryProtocol {
	
	/// The storage provider
	private let storage: FileStorageProtocol
	
	/// The name of file in which we store the items
	private let fileName: String 
	
	/// Dispatch Queue
	private let queue = DispatchQueue(label: "com.FileRepository.serialqueue.\(UUID().uuidString)")
	
	/// Observatory for changes
	public let observatory: Observatory<(Item?, FileRepositoryReason)>
	
	/// Observers for changes
	private let observers: ((Item?, FileRepositoryReason)) -> Void
	
	/// The list of stored items
	public var items: [Item]
	
	/// Initializer
	/// - Parameter storage: storage protocol
	public init(storage: FileStorageProtocol = FileStorage(), fileName: String) {
		
		self.storage = storage
		self.fileName = fileName
		(self.observatory, self.observers) = Observatory<(Item?, FileRepositoryReason)>.create()
		
		self.items = []
		do {
			try self.items = read()
		} catch {
			logError("FileRepository - error initializing ", error)
			self.items = []
		}
	}
	
	/// Add an item to the storage
	/// - Parameter item: the item to store
	public func store(_ item: Item) throws {
		
		guard !items.contains(item) else {
			// Can't add twice
			return
		}

		items.append(item)
		observers((item, FileRepositoryReason.added))
		try persistToStorage()
	}
	
	/// Get a list of all the stored items
	/// - Returns: array of stored items
	internal func read() throws -> [Item] {
		
		if let jsonData = storage.read(fileName: fileName) {
			let data = try JSONDecoder().decode([Item].self, from: jsonData)
			return data
		}
		return []
	}
	
	/// Delete an item from storage
	/// - Parameter item: the item to be removed
	public func remove(_ item: Item) throws {
	
		logInfo("About to delete \(item)")
		items = items.filter { $0 != item }
		observers((item, FileRepositoryReason.removed))
		try persistToStorage()
	}
	
	/// set the list of items
	/// - Parameter new: the item to be stored
	public func set(_ new: [Item]) throws {
		
		items = new
		observers((nil, FileRepositoryReason.changed))
		try persistToStorage()
	}
	
	/// Remove all the stored items
	public func wipePersistedData() {
		
		items = []
		storage.remove(fileName)
	}
	
	/// Store a list of items to disk
	private func persistToStorage() throws {
		
		try queue.sync {
			let encoded = try JSONEncoder().encode(items)
			try storage.store(encoded, as: fileName)
		}
	}
}

