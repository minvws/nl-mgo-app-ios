/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import Zibs

protocol BinaryRepositoryProtocol {
	
	func store(_ binary: Zibs.MgoBinary, as filename: String) throws -> URL

	/// Clear all documents
	func clear()
}

public enum  BinaryRepositoryError: Error {
	
	case noUrl
	case couldNotSaveBinary
}

class BinaryRepository: BinaryRepositoryProtocol {
	
	private let fileManager = FileManager.default
	
	init() {
		
		createDirectoryIfNeeded(at: documentsURL)
	}
	
	private func createDirectoryIfNeeded(at url: URL?) {
		
		guard let url else { return }
				
		if !fileManager.fileExists(atPath: url.path) {
			try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)
		}
	}
	
	/// Get url to documents directory
	private var documentsURL: URL? {
		
		return fileManager
			.urls(for: .documentDirectory, in: .userDomainMask)
			.first?
			.appendingPathComponent("binary", isDirectory: true)
	}
	
	func store(_ binary: Zibs.MgoBinary, as filename: String) throws -> URL {
		
		guard let documentsURL else { throw BinaryRepositoryError.noUrl }
		
		let fileUrl = documentsURL.appendingPathComponent(filename)
		
		if let content = Data(base64Encoded: binary.content),
		   fileManager.createFile(atPath: fileUrl.path, contents: content) {
			return fileUrl
		}
		throw BinaryRepositoryError.couldNotSaveBinary
	}
	
	func clear() {
		
		guard let url = documentsURL else { return }
		
		do {
			try fileManager.removeItem(atPath: url.path)
		} catch {
			logError("🗄️🗄️: Failed to clear directory \(error)")
		}
	}
}
