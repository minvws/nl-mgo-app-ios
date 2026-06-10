/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import HTTPTypes
import Testing
@testable import FHIRClient

@Suite struct DataResponseTests {
	
	private let httpResponse = HTTPResponse(status: .ok)
	
	// MARK: - init(error:handler:)
	
	@Test("NSURLError is mapped to .requestError with status 0")
	func initWithError_nsURLError_mapsToRequestError() {
		
		// Given
		let error = NSError(
			domain: NSURLErrorDomain,
			code: URLError.timedOut.rawValue
		)
		
		// When
		let response = DataResponse(error: error)
		
		// Then
		guard case .requestError(let status, let message) = response.error else {
			Issue.record("Expected .requestError, got \(String(describing: response.error))")
			return
		}
		#expect(status == 0)
		#expect(message == error.humanized)
	}
	
	@Test("FHIRError is preserved as-is")
	func initWithError_fhirError_preservesFHIRError() {
		
		// Given / When
		let response = DataResponse(error: FHIRError.noResponseReceived)
		
		// Then
		guard case .noResponseReceived = response.error else {
			Issue.record("Expected .noResponseReceived, got \(String(describing: response.error))")
			return
		}
	}
	
	@Test("Generic error is mapped to .error using string interpolation")
	func initWithError_genericError_mapsToFHIRErrorError() {
		
		// Given
		let genericError = NSError(domain: "SomeDomain", code: 42)
		
		// When
		let response = DataResponse(error: genericError)
		
		// Then
		guard case .error(let message) = response.error else {
			Issue.record("Expected .error, got \(String(describing: response.error))")
			return
		}
		#expect(message == "\(genericError)")
	}
	
	// MARK: - init(handler:response:data:error:)
	
	@Test("NSURLError is mapped to .requestError with the HTTP response status code")
	func initWithResponse_nsURLError_mapsToRequestError() {
		
		// Given
		let error = NSError(
			domain: NSURLErrorDomain,
			code: URLError.timedOut.rawValue
		)
		
		// When
		let response = DataResponse(
			response: httpResponse,
			data: nil,
			error: error
		)
		
		// Then
		guard case .requestError(let status, let message) = response.error else {
			Issue.record("Expected .requestError, got \(String(describing: response.error))")
			return
		}
		#expect(status == httpResponse.status.code)
		#expect(message == error.humanized)
	}
	
	@Test("FHIRError is preserved as-is")
	func initWithResponse_fhirError_preservesFHIRError() {
		
		// Given / When
		let response = DataResponse(
			response: httpResponse,
			data: nil,
			error: FHIRError.responseNoResourceReceived
		)
		
		// Then
		guard case .responseNoResourceReceived = response.error else {
			Issue.record("Expected .responseNoResourceReceived, got \(String(describing: response.error))")
			return
		}
	}
	
	@Test("Generic error is mapped to .error using localizedDescription")
	func initWithResponse_genericError_mapsToFHIRErrorError() {
		
		// Given
		let genericError = NSError(domain: "SomeDomain", code: 42)
		
		// When
		let response = DataResponse(
			response: httpResponse,
			data: nil,
			error: genericError
		)
		
		// Then
		guard case .error(let message) = response.error else {
			Issue.record("Expected .error, got \(String(describing: response.error))")
			return
		}
		#expect(message == genericError.localizedDescription)
	}
	
	@Test("nil error results in a nil error property")
	func initWithResponse_nilError_hasNilError() {
		
		// Given / When
		let response = DataResponse(
			response: httpResponse,
			data: nil,
			error: nil
		)
		
		// Then
		#expect(response.error == nil)
	}
}
