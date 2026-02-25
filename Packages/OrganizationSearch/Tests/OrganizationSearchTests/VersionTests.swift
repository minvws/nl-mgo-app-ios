/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing
import Foundation

class VersionTests {
	
	@Test("Version initialization throws error with invalid JSON data")
	func versionInvalidJSONError() throws {
		
		// Given
		// Create malformed JSON that will fail to decode
		let invalidJSON = """
		{
			"version": "test",
			"invalid_key": "value"
		}
		"""
		
		// When / Then
		// This should throw a decoding error because required fields are missing
		#expect(throws: (any Error).self) {
			_ = try Version(invalidJSON)
		}
	}
	
	@Test("Version initialization throws error with corrupted data")
	func versionCorruptedDataError() throws {
		
		// Given
		// Create data that is not valid JSON
		let corruptedData = Data([0xFF, 0xFE, 0xFD, 0xFC])
		
		// When / Then
		// This should throw a decoding error
		#expect(throws: (any Error).self) {
			_ = try Version(data: corruptedData)
		}
	}
	
	@Test("Version initialization succeeds with valid JSON string")
	func versionSuccessfulInitialization() throws {
		
		// Given
		let validJSON = """
		{
			"version": "1.0.0",
			"git_ref": "abc123def456",
			"created": "2026-02-12T10:00:00"
		}
		"""
		
		// When
		let version = try Version(validJSON)
		
		// Then
		#expect(version.version == "1.0.0")
		#expect(version.gitRef == "abc123def456")
		#expect(version.created == "2026-02-12T10:00:00")
	}
	
	@Test("Version initialization with Data succeeds")
	func versionInitializationWithData() throws {
		
		// Given
		let validJSON = """
		{
			"version": "2.0.0",
			"git_ref": "xyz789",
			"created": "2026-02-12T11:00:00"
		}
		"""
		let data = validJSON.data(using: .utf8)!
		
		// When
		let version = try Version(data: data)
		
		// Then
		#expect(version.version == "2.0.0")
		#expect(version.gitRef == "xyz789")
		#expect(version.created == "2026-02-12T11:00:00")
	}
	
	@Test("Version initialization throws invalidResource when encoding fails")
	func versionEncodingFailure() throws {
		
		// Given
		// To trigger the encoding error on line 61, we need json.data(using: encoding) to return nil
		// In practice, this is very difficult with standard Swift strings and encodings
		// We'll simulate this by using a string that contains characters that cannot be
		// represented in a specific encoding
		
		// Create a string with emoji and special characters
		let jsonWithEmoji = """
		{
			"version": "test 🎉",
			"git_ref": "abc",
			"created": "2026-01-01"
		}
		"""
		
		// ASCII encoding cannot represent emoji, so data(using:) should return nil
		// When / Then
		#expect(throws: Version.Error.invalidResource) {
			_ = try Version(jsonWithEmoji, using: .ascii)
		}
	}
}
