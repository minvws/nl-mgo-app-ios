/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class FileManagerSpy: FileManagerProtocol {
	
	public init() { /* public initializer for public access */ }

	public var invokedCreateDirectoryAt = false
	public var invokedCreateDirectoryAtCount = 0
	public var invokedCreateDirectoryAtParameters: (url: URL, createIntermediates: Bool, attributes: [FileAttributeKey: Any]?)?
	public var invokedCreateDirectoryAtParametersList = [(url: URL, createIntermediates: Bool, attributes: [FileAttributeKey: Any]?)]()
	public var stubbedCreateDirectoryAtError: Error?

	public func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws {
		invokedCreateDirectoryAt = true
		invokedCreateDirectoryAtCount += 1
		invokedCreateDirectoryAtParameters = (url, createIntermediates, attributes)
		invokedCreateDirectoryAtParametersList.append((url, createIntermediates, attributes))
		if let error = stubbedCreateDirectoryAtError {
			throw error
		}
	}

	public var invokedCreateDirectoryAtPath = false
	public var invokedCreateDirectoryAtPathCount = 0
	public var invokedCreateDirectoryAtPathParameters: (path: String, createIntermediates: Bool, attributes: [FileAttributeKey: Any]?)?
	public var invokedCreateDirectoryAtPathParametersList = [(path: String, createIntermediates: Bool, attributes: [FileAttributeKey: Any]?)]()
	public var stubbedCreateDirectoryAtPathError: Error?

	public func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws {
		invokedCreateDirectoryAtPath = true
		invokedCreateDirectoryAtPathCount += 1
		invokedCreateDirectoryAtPathParameters = (path, createIntermediates, attributes)
		invokedCreateDirectoryAtPathParametersList.append((path, createIntermediates, attributes))
		if let error = stubbedCreateDirectoryAtPathError {
			throw error
		}
	}

	public var invokedCreateFile = false
	public var invokedCreateFileCount = 0
	public var invokedCreateFileParameters: (path: String, data: Data?, attr: [FileAttributeKey: Any]?)?
	public var invokedCreateFileParametersList = [(path: String, data: Data?, attr: [FileAttributeKey: Any]?)]()
	public var stubbedCreateFileResult: Bool! = false

	public func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey: Any]?) -> Bool {
		invokedCreateFile = true
		invokedCreateFileCount += 1
		invokedCreateFileParameters = (path, data, attr)
		invokedCreateFileParametersList.append((path, data, attr))
		return stubbedCreateFileResult
	}

	public var invokedFileExists = false
	public var invokedFileExistsCount = 0
	public var invokedFileExistsParameters: (path: String, Void)?
	public var invokedFileExistsParametersList = [(path: String, Void)]()
	public var stubbedFileExistsResult: Bool! = false

	public func fileExists(atPath path: String) -> Bool {
		invokedFileExists = true
		invokedFileExistsCount += 1
		invokedFileExistsParameters = (path, ())
		invokedFileExistsParametersList.append((path, ()))
		return stubbedFileExistsResult
	}

	public var invokedRemoveItem = false
	public var invokedRemoveItemCount = 0
	public var invokedRemoveItemParameters: (path: String, Void)?
	public var invokedRemoveItemParametersList = [(path: String, Void)]()
	public var stubbedRemoveItemError: Error?

	public func removeItem(atPath path: String) throws {
		invokedRemoveItem = true
		invokedRemoveItemCount += 1
		invokedRemoveItemParameters = (path, ())
		invokedRemoveItemParametersList.append((path, ()))
		if let error = stubbedRemoveItemError {
			throw error
		}
	}

	public var invokedUrls = false
	public var invokedUrlsCount = 0
	public var invokedUrlsParameters: (directory: FileManager.SearchPathDirectory, domainMask: FileManager.SearchPathDomainMask)?
	public var invokedUrlsParametersList = [(directory: FileManager.SearchPathDirectory, domainMask: FileManager.SearchPathDomainMask)]()
	public var stubbedUrlsResult: [URL]! = []

	public func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
		invokedUrls = true
		invokedUrlsCount += 1
		invokedUrlsParameters = (directory, domainMask)
		invokedUrlsParametersList.append((directory, domainMask))
		return stubbedUrlsResult
	}
}
