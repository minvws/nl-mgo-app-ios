/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import HTTPTypes
import HTTPTypesFoundation

public actor FHIRClient {
	
	/// The server's base URL.
	public final let baseURL: URL
	
	/// Create a FHIR Client
	/// - Parameter base: the base url.
	public init(baseURL base: URL) {
		// Makes sure the base URL ends with a "/" to facilitate URL generation later on.
		if let last = base.absoluteString.last, last != "/" {
			baseURL = base.appendingPathComponent("/")
		} else {
			baseURL = base
		}
	}
	
	// MARK: - URL
	
	/**
	 Creates an absolute URL from the receiver's `baseURL` and the given path.
	 
	 - parameter for: The path in the absolute URL
	 */
	public func absoluteURL(for path: String) -> URL? {
		
		var myPath = path
		myPath = myPath.replacingOccurrences(of: "|", with: "%7C")
		return URL(string: myPath, relativeTo: baseURL)
	}
	
	// MARK: - Requests
	
	/**
	 Returns the request handler for the given HTTP method.
	 
	 - parameter method: The request method (GET, PUT, POST or DELETE)
	 - returns:          A `RequestHandlerImpl` for the given method
	 */
	public func handlerForRequest(withMethod method: HTTPRequest.Method) -> RequestHandlerImpl {
		return RequestHandlerImpl(method)
	}
	
	/**
	 Pre-prepare a mutable URLRequest that the handler subsequently prepares and performs.
	 */
	public func configurableRequest(for url: URL) -> URLRequest {
		return URLRequest(url: url)
	}
	
	/**
	 Execute a request against a path relative to the server's base URL.
	 */
	func performRequest(
		against path: String,
		handler: RequestHandlerImpl
	) async -> DataResponse {
		
		guard let url = absoluteURL(for: path) else {
			return handler.notSent("Failed to parse path «\(path)» relative to server base URL")
		}
		return await performRequest(on: url, handler: handler)
	}
	
	/**
	 Execute a request against an absolute URL.
	 
	 The handler prepares the `URLRequest`, the actor performs it via `URLSession`, and the resulting
	 `URLResponse`/`Data`/`Error` triple is bridged into `HTTPResponse` for the handler to consume.
	 */
	func performRequest(
		on url: URL,
		handler: RequestHandlerImpl
	) async -> DataResponse {
		
		var request = configurableRequest(for: url)
		do {
			try handler.prepare(request: &request)
			let (data, urlResponse, error) = await perform(request: request)
			let httpResponse = (urlResponse as? HTTPURLResponse)?.httpResponse
			return handler.response(response: httpResponse, data: data, error: error)
		} catch let error {
			return handler.notSent("Failed to prepare request against \(url): \(error)")
		}
	}
	
	/**
	 Performs the URLRequest via the shared URLSession.
	 */
	public func perform(request: URLRequest) async -> (Data?, URLResponse?, Error?) {
		
		await withCheckedContinuation { continuation in
			_ = perform(request: request) { data, response, error in
				continuation.resume(returning: (data, response, error))
			}
		}
	}
	
	@discardableResult
	public func perform(
		request: URLRequest,
		completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void
	) -> URLSessionTask? {
		
		let task = Foundation.URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
		task.resume()
		return task
	}
}
