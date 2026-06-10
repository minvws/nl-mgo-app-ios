/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Testing
@testable import FHIRClient

@Suite struct ErrorHumanizedTests {
	
	@Test("Non-NSURLErrorDomain error returns localizedDescription")
	func nonURLError_returnsLocalizedDescription() {
		let error = NSError(domain: "SomeDomain", code: 42)
		#expect(error.humanized == error.localizedDescription)
	}
	
	@Test("NSURLErrorBadURL returns human-readable message")
	func badURL_returnsHumanizedString() {
		let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL)
		#expect(error.humanized == "The URL was malformed".fhirLocalized)
	}
	
	@Test("NSURLErrorTimedOut returns human-readable message")
	func timedOut_returnsHumanizedString() {
		let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
		#expect(error.humanized == "The connection timed out".fhirLocalized)
	}
	
	@Test("NSURLErrorUnsupportedURL returns human-readable message")
	func unsupportedURL_returnsHumanizedString() {
		let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnsupportedURL)
		#expect(error.humanized == "The URL scheme is not supported".fhirLocalized)
	}
	
	@Test("NSURLErrorCannotFindHost returns human-readable message")
	func cannotFindHost_returnsHumanizedString() {
		let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotFindHost)
		#expect(error.humanized == "The host could not be found".fhirLocalized)
	}
	
	@Test("NSURLErrorCannotConnectToHost returns human-readable message")
	func cannotConnectToHost_returnsHumanizedString() {
		let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost)
		#expect(error.humanized == "A connection to the host cannot be established".fhirLocalized)
	}
	
	@Test("NSURLErrorNetworkConnectionLost returns human-readable message")
	func networkConnectionLost_returnsHumanizedString() {
		let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost)
		#expect(error.humanized == "The network connection was lost".fhirLocalized)
	}
	
	@Test("NSURLErrorDNSLookupFailed returns human-readable message")
	func dnsLookupFailed_returnsHumanizedString() {
		let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorDNSLookupFailed)
		#expect(error.humanized == "The connection failed because the DNS lookup failed".fhirLocalized)
	}
	
	@Test("NSURLErrorHTTPTooManyRedirects returns human-readable message")
	func httpTooManyRedirects_returnsHumanizedString() {
		let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorHTTPTooManyRedirects)
		#expect(error.humanized == "The HTTP connection failed due to too many redirects".fhirLocalized)
	}
	
	@Test("Unknown NSURLErrorDomain code falls back to localizedDescription")
	func unknownCode_returnsLocalizedDescription() {
		let error = NSError(domain: NSURLErrorDomain, code: 999_999)
		#expect(error.humanized == error.localizedDescription)
	}
}
