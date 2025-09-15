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
	
	/// Get the url to the file
	/// - Parameter fileName: the name of the file
	/// - Returns: optional url to the file
	func fileUrl(_ fileName: String) -> URL?
}

final public class FileStorage: FileStorageProtocol {
	
	/// The underlying file manager
	private let fileManager: FileManagerProtocol
	
	/// Initializer
	/// - Parameter fileManager: the File Manager
	/// - Parameter subDirectory: an optional sub directory for storage
	public init(fileManager: FileManagerProtocol = FileManager.default, subDirectory: String? = nil) {
		
		self.fileManager = fileManager
		self.subDirectory = subDirectory
		createSubDirectoryIfNeeded()
	}
	
	/// Create the sub directory if needed
	private func createSubDirectoryIfNeeded() {
		
		guard let subDirectory, let documentsURL else { return }
		let subDirectoryUrl = documentsURL.appendingPathComponent(subDirectory, isDirectory: true)
		if !fileManager.fileExists(atPath: subDirectoryUrl.path) {
			try? fileManager.createDirectory(
				at: subDirectoryUrl,
				withIntermediateDirectories: true,
				attributes: [.protectionKey: FileProtectionType.complete]
			)
		}
	}
	
	/// An optional sub directory
	private var subDirectory: String?
	
	/// Get url to documents directory
	private var documentsURL: URL? {
		
		return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
	}
	
	/// Get the url to the file
	/// - Parameter fileName: the name of the file
	/// - Returns: optional url to the file
	public func fileUrl(_ fileName: String) -> URL? {
		
		guard let documentsURL else { return nil }
		if let subDirectory {
			return documentsURL
				.appendingPathComponent(subDirectory, isDirectory: true)
				.appendingPathComponent(fileName, isDirectory: false)
		} else {
			return documentsURL
				.appendingPathComponent(fileName, isDirectory: false)
		}
	}
	
	/// Common directory error
	private let directoryError = "🗄️🗄️: Failed to load documents directory"
	
	/// Store data in documents directory
	/// - Parameters:
	///   - data: Store data
	///   - fileName: Name of file
	/// - Throws
	public func store(_ data: Data, as fileName: String) throws {
		
		guard let url = fileUrl(fileName) else {
			logError(directoryError)
			return
		}
		try data.write(to: url, options: [.atomic, .completeFileProtection])
	}
	
	/// Get the content of a file
	/// - Parameter fileName: the name of the file
	/// - Returns: the content
	public func read(fileName: String) -> Data? {
		
		guard let url = fileUrl(fileName) else {
			logError(directoryError)
			return nil
		}
		
		guard fileManager.fileExists(atPath: url.path) else {
			logError("🗄️🗄️: No such file \(fileName)")
			return nil
		}
		
		do {
			let data = try Data(contentsOf: url)
			return data
		} catch {
			logError("🗄️🗄️: Failed to read file \(url)")
			return nil
		}
	}
	
	/// Check if a file exists
	/// - Parameter fileName: the name of the file
	/// - Returns: True if it does.
	public func fileExists(_ fileName: String) -> Bool {
		
		guard let url = fileUrl(fileName) else {
			logError(directoryError)
			return false
		}
		
		return fileManager.fileExists(atPath: url.path)
	}
	
	/// Remove a file or directory
	/// - Parameter fileName: the name of the file or directory
	public func remove(_ fileName: String) {
		
		guard fileExists(fileName) else { return }
		
		guard let url = fileUrl(fileName) else {
			logError(directoryError)
			return
		}
		do {
			try fileManager.removeItem(atPath: url.path)
		} catch {
			logError("🗄️🗄️: Failed to read directory \(error)")
		}
	}
}
