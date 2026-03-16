/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FileStorage
import Foil
import SwiftLogging

public protocol PatientFriendlyTermsRepositoryProtocol {
	
	var eTag: String? { get set }
	
	/// Fetch the patient friendly terms
	func fetchTerms() async
	
	/// Find a patient friendly term
	/// - Parameter code: the SnomedCT code
	/// - Returns: a patient friendly term for that code
	func find(_ code: String) -> PatientFriendlyTerm?
	
	/// Remove the patient friendly terms from storage
	func wipePersistedData()
}

public class PatientFriendlyTermsRepository: PatientFriendlyTermsRepositoryProtocol {
	
	/// The SnomedCT system
	public static let snomedCTSystem: String = "http://snomed.info/sct" // NOSONAR
	
	@usableFromInline
	static let directory = "PFT"
	
	/// The storage provider
	private let storage: FileStorageProtocol
	
	/// The API Client
	private let client: PatientFriendlyTermsAPIClientProtocol
	
	/// The name of the file where we store the patient friendly terms
	private let fileName: String = {
		
		if NSClassFromString("XCTestCase") == nil {
			return "pft.json"
		} else {
			return "pft-test.json"
		}
	}()
	
	/// The name of the ETag key where we store the resources ETag
	static let eTagKey: String = {
		
		if NSClassFromString("XCTestCase") == nil {
			return "PFTAPI-Terms-ETag"
		} else {
			return "PFTAPI-Terms-Test-ETag"
		}
	}()
	
	/// The ETag for the terms
	@FoilDefaultStorageOptional(key: eTagKey)
	public var eTag: String?
	
	/// Create a Patient Friendly Terms Repository
	/// - Parameters:
	///   - client: the api client
	///   - storage: the storage client
	public init(
		client: PatientFriendlyTermsAPIClientProtocol,
		storage: FileStorageProtocol = FileStorage(subDirectory: PatientFriendlyTermsRepository.directory)
	) {
		self.client = client
		self.storage = storage
	}
	
	/// Fetch the terms from the server
	public func fetchTerms() async {
		do {
			let (status, newETag, body) = try await client.fetchTerms(eTag: eTag)
			switch status {
				case 200:
				if let body {
					let encoded = try JSONEncoder().encode(body)
					try storage.store(encoded, as: fileName)
					self.eTag = newETag
					logDebug("PFTRep - Stored \(body.additionalProperties.count) patient friendly terms with eTag: \(String(describing: self.eTag))")
					loadData()
				}
				case 304:
					logDebug("PFTRep - 304 Not Modified")
					self.eTag = newETag
					loadData()
				default:
					break
			}
		} catch {
			logError("PFTRep - fetch terms error:", error)
		}
	}
	
	/// Clear all the things
	public func wipePersistedData() {
		
		storage.remove(fileName)
		eTag = nil
	}
	
	/// The Patient Friendly Terms
	internal var terms: [String: PatientFriendlyTerm] = [:]
	
	// Load all the data
	private func loadData() {
		if let data = storage.read(fileName: fileName) {
			
			let decoded = try? JSONDecoder().decode(PatientFriendlyTerms.self, from: data)
			terms = decoded?.additionalProperties ?? [:]
		}
	}
	
	/// Find a patient friendly term
	/// - Parameter code: the SnomedCT code
	/// - Returns: a patient friendly term for that code
	public func find(_ code: String) -> PatientFriendlyTerm? {
		
		if terms.isEmpty {
			loadData()
		}
		
		return terms[code]
	}
}
