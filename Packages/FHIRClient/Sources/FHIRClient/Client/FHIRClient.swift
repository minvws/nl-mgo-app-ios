/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

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
	This method simply creates an absolute URL from the receiver's `baseURL` and the given path.
	
	A chance for subclasses to mess with URL generation if needed.
	
	- parameter for: The path in the absolute URL
	*/
	public func absoluteURL(for path: String) -> URL? {
		return URL(string: path, relativeTo: baseURL)
	}
	
	// MARK: - Requests
	
	/**
	The server can return the appropriate request handler for the type and resource combination.
	
	Request handlers are responsible for constructing an URLRequest that correctly performs the desired REST interaction.
	
	- parameter method:   The request method (GET, PUT, POST or DELETE)
	
	- returns:            An appropriate `RequestHandler`, for example a _FHIRJSONRequestHandler_ if sending and receiving JSON
	*/
	public func handlerForRequest(withMethod method: RequestMethod) -> RequestHandler {
		return RequestHandlerImpl(method)
	}
	
	/**
	Pre-prepare a mutable URLRequest that the handler subsequently prepares and performs.
	
	This implementation simply creates an `URLRequest` against the given url.
	
	- parameter url: The url to use for the request
	- returns: A URLRequest instance
	*/
	public func configurableRequest(for url: URL) -> URLRequest {
		return URLRequest(url: url)
	}
	
	/**
	 Method to execute a request against a given relative URL with a given request/response handler.
	 This is the async version
	 
	 - parameter path:     The path, relative to the server's base; may include URL query and URL fragment (!)
	 - parameter handler:  The FHIRRequestHandler that prepares the request and processes the response
	 - Returns:  the server response
	 */
	
	func performRequest(
		against path: String,
		handler: RequestHandler
	) async -> ServerResponse {
		
		guard let url = absoluteURL(for: path) else {
			return handler.notSent("Failed to parse path «\(path)» relative to server base URL")
		}
		return await performRequest(on: url, handler: handler)
	}
	
	/**
	 Method to execute a request against a given absolute URL with a given request/response handler.
	 This is the async version
	 
	 This method will use the request handler to prepare the request (i.e. add headers and prepare body data), then hand it over to
	 `perform(request:completionHandler:)` to actually perform the request. Finally, the response data/URLResponse/error is handed to the
	 request handler and converted into the `FHIRServerResponse` that is delivered to you in the callback.
	 
	 - parameter url:      The full URL; may include query parts and fragment (!)
	 - parameter handler:  The FHIRRequestHandler that prepares the request and processes the response
	 - Returns: the server response
	 */
	
	func performRequest(
		on url: URL,
		handler: RequestHandler
	) async -> ServerResponse {
		
		var request = configurableRequest(for: url)
		do {
			try handler.prepare(request: &request)
			let (data, response1, error) = await perform(request: request)
			return handler.response(response: response1, data: data, error: error)
		} catch let error {
			return handler.notSent("Failed to prepare request against \(url): \(error)")
		}
	}
	
	/**
	 This is the last method in the chain to actually perform a request. Uses `URLSession().dataTask(with:completionHandler:)`.
	 This is the async wrapper
	 
	 - parameter request:           The URL request to perform as-is
	 - returns:                     returning optional data, response and error instances, when all has completed
	 */
	public func perform(request: URLRequest) async -> (Data?, URLResponse?, Error?) {
		
		await withCheckedContinuation { continuation in
			_ = perform(request: request) { data, response, error in
				continuation.resume(returning: (data, response, error))
			}
		}
	}
	
	/**
	 This is the last method in the chain to actually perform a request. Uses `URLSession().dataTask(with:completionHandler:)`.
	 
	 - parameter request:           The URL request to perform as-is
	 - parameter completionHandler: The completion handler, returning optional data, response and error instances, when all has completed
	 - returns:                     A URLSessionTask that is already under way
	 */
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
