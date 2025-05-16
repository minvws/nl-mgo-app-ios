/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug

public protocol FileStorageProtocol: AnyObject {
	
	/// Store data in documents directory
	/// - Parameters:
	///   - data: Store data
	///   - fileName: Name of file
	/// - Throws
	func store(_ data: Data, as fileName: String) throws
	
	/// Get the content of a file
	/// - Parameter fileName: the name of the file
	/// - Returns: the content
	func read(fileName: String) -> Data?
	
	/// Check if a file exists
	/// - Parameter fileName: the name of the file
	/// - Returns: True if it does.
	func fileExists(_ fileName: String) -> Bool
	
	/// Check if a file exists
	/// - Parameter fileName: the name of the file
	/// - Returns: True if it does.
	func remove(_ fileName: String)
	
	/// Get url to documents directory
	var documentsURL: URL? { get }
}

final public class FileStorage: FileStorageProtocol {
	
	/// The underlying file manager
	private let fileManager: FileManagerProtocol
	
	/// Initializer
	/// - Parameter fileManager: the File Manager
	public init(fileManager: FileManagerProtocol = FileManager.default) {
		
		self.fileManager = fileManager
	}
	
	/// Get url to documents directory
	public var documentsURL: URL? {
		
		return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
	}
	
	/// Common directory error
	private let directoryError = "🗄️🗄️: Failed to load documents directory"
	
	/// Store data in documents directory
	/// - Parameters:
	///   - data: Store data
	///   - fileName: Name of file
	/// - Throws
	public func store(_ data: Data, as fileName: String) throws {
		
		guard let url = documentsURL else {
			logError(directoryError)
			return
		}
		let fileUrl = url.appendingPathComponent(fileName, isDirectory: false)
		
		try fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
		try data.write(to: fileUrl, options: .atomic)
	}
	
	/// Get the content of a file
	/// - Parameter fileName: the name of the file
	/// - Returns: the content
	public func read(fileName: String) -> Data? {
		
		guard let url = documentsURL else {
			logError(directoryError)
			return nil
		}
		let fileUrl = url.appendingPathComponent(fileName, isDirectory: false)
		
		guard fileManager.fileExists(atPath: fileUrl.path) else {
			logError("🗄️🗄️: No such file \(fileName)")
			return nil
		}
		
		do {
			let data = try Data(contentsOf: fileUrl)
			return data
		} catch {
			logError("🗄️🗄️: Failed to read file \(fileUrl)")
			return nil
		}
	}
	
	/// Check if a file exists
	/// - Parameter fileName: the name of the file
	/// - Returns: True if it does.
	public func fileExists(_ fileName: String) -> Bool {
		
		guard let url = documentsURL else {
			logError(directoryError)
			return false
		}
		
		let fileUrl = url.appendingPathComponent(fileName, isDirectory: false)
		return fileManager.fileExists(atPath: fileUrl.path)
	}
	
	/// Check if a file exists
	/// - Parameter fileName: the name of the file
	/// - Returns: True if it does.
	public func remove(_ fileName: String) {
		
		guard let url = documentsURL else {
			logError(directoryError)
			return
		}
		
		let fileUrl = url.appendingPathComponent(fileName, isDirectory: false)
		do {
			try fileManager.removeItem(atPath: fileUrl.path)
		} catch {
			logError("🗄️🗄️: Failed to read directory \(error)")
		}
	}
}
