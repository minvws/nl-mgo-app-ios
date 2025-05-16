/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

protocol BinaryRepositoryProtocol {
	
	/// Store an Zibs FHIRBinary
	/// - Parameters:
	///   - binary: the binary to store
	///   - filename: the filename to store it with
	/// - Returns: the path to the stored file
	func store(_ binary: FHIRBinary, as filename: String) throws -> URL
	
	/// Clear all documents
	func clear()
}

public enum  BinaryRepositoryError: Error {
	
	case noUrl
	case couldNotSaveBinary
}

class BinaryRepository: BinaryRepositoryProtocol {
	
	private let fileManager: FileManagerProtocol
	
	/// Create a Binary Repository
	init(fileManager: FileManagerProtocol = FileManager.default) {
		
		self.fileManager = fileManager
		createDirectoryIfNeeded(at: documentsURL)
	}
	
	/// Check if we need to crate the binary directory
	/// - Parameter url: the url to create
	private func createDirectoryIfNeeded(at url: URL?) {
		
		guard let url else { return }
		
		if !fileManager.fileExists(atPath: url.path) {
			try? fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
		}
	}
	
	/// Get url to documents directory
	private var documentsURL: URL? {
		
		return fileManager
			.urls(for: .documentDirectory, in: .userDomainMask)
			.first?
			.appendingPathComponent("binary", isDirectory: true)
	}
	
	/// Store an SharedCore FHIRBinary
	/// - Parameters:
	///   - binary: the binary to store
	///   - filename: the filename to store it with
	/// - Returns: the path to the stored file
	func store(_ binary: FHIRBinary, as filename: String) throws -> URL {
		
		guard let documentsURL else { throw BinaryRepositoryError.noUrl }
		
		let fileUrl = documentsURL.appendingPathComponent(filename)
		
		if let content = Data(base64Encoded: binary.content),
		   fileManager.createFile(atPath: fileUrl.path, contents: content, attributes: nil) {
			return fileUrl
		}
		
		throw BinaryRepositoryError.couldNotSaveBinary
	}
	
	/// Clear all documents
	func clear() {
		
		guard let url = documentsURL else { return }
		
		do {
			try fileManager.removeItem(atPath: url.path)
		} catch {
			logError("🗄️🗄️: Failed to clear directory \(error)")
		}
	}
}
