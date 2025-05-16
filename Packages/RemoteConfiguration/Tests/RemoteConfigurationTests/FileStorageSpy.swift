/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FileStorage

public class FileStorageSpy: FileStorageProtocol {

	public var invokedDocumentsURLGetter = false
	public var invokedDocumentsURLGetterCount = 0
	public var stubbedDocumentsURL: URL!

	public var documentsURL: URL? {
		invokedDocumentsURLGetter = true
		invokedDocumentsURLGetterCount += 1
		return stubbedDocumentsURL
	}

	public var invokedStore = false
	public var invokedStoreCount = 0
	public var invokedStoreParameters: (data: Data, fileName: String)?
	public var invokedStoreParametersList = [(data: Data, fileName: String)]()
	public var stubbedStoreError: Error?

	public func store(_ data: Data, as fileName: String) throws {
		invokedStore = true
		invokedStoreCount += 1
		invokedStoreParameters = (data, fileName)
		invokedStoreParametersList.append((data, fileName))
		if let error = stubbedStoreError {
			throw error
		}
	}

	public var invokedRead = false
	public var invokedReadCount = 0
	public var invokedReadParameters: (fileName: String, Void)?
	public var invokedReadParametersList = [(fileName: String, Void)]()
	public var stubbedReadResult: Data!

	public func read(fileName: String) -> Data? {
		invokedRead = true
		invokedReadCount += 1
		invokedReadParameters = (fileName, ())
		invokedReadParametersList.append((fileName, ()))
		return stubbedReadResult
	}

	public var invokedFileExists = false
	public var invokedFileExistsCount = 0
	public var invokedFileExistsParameters: (fileName: String, Void)?
	public var invokedFileExistsParametersList = [(fileName: String, Void)]()
	public var stubbedFileExistsResult: Bool! = false

	public func fileExists(_ fileName: String) -> Bool {
		invokedFileExists = true
		invokedFileExistsCount += 1
		invokedFileExistsParameters = (fileName, ())
		invokedFileExistsParametersList.append((fileName, ()))
		return stubbedFileExistsResult
	}

	public var invokedRemove = false
	public var invokedRemoveCount = 0
	public var invokedRemoveParameters: (fileName: String, Void)?
	public var invokedRemoveParametersList = [(fileName: String, Void)]()

	public func remove(_ fileName: String) {
		invokedRemove = true
		invokedRemoveCount += 1
		invokedRemoveParameters = (fileName, ())
		invokedRemoveParametersList.append((fileName, ()))
	}
}
