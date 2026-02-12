/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import JavaScriptCore
import MGODebug

/// Actor to manage JavaScript context on a background thread
/// JSContext must be accessed from the same thread it was created on
actor JSContextManager {
	
	/// The namespace used in the JavaScript context
	static let nameSpace = "OrgSearchApi"
	
	/// the JavaScript Context
	private var jsContext: JSContext?
	
	/// Have we indexed the providers?
	private var providersHaveBeenIndexed: Bool = false
	
	/// Track if initialization is complete
	private var isInitialized: Bool = false
	
	init() {
		// Actor initializers are non-isolated, so we can't call actor-isolated methods here
		// Initialization will be done lazily on first use
	}
	
	/// Ensure the JS context is initialized (called before any JS operations)
	private func ensureInitialized() throws {
		guard !isInitialized else { return }
		
		jsContext = createContext()
		try loadSource(jsContext: jsContext)
		
		isInitialized = true
	}
	
	/// Create the JavaScript Context
	/// - Returns: the JavaScript Context
	private func createContext() -> JSContext? {
		
		let context = JSContext()
		// Add logging for exceptions
		context?.exceptionHandler = { (ctx: JSContext!, value: JSValue!) in
			// type of String
			let stackTrace = value.objectForKeyedSubscript("stack").toString()
			// type of Number
			let lineNumber = value.objectForKeyedSubscript("line")
			// type of Number
			let column = value.objectForKeyedSubscript("column")
			let moreInfo = "in method \(String(describing: stackTrace)) Line number in file: \(String(describing: lineNumber)), column: \(String(describing: column))"
			logError("JSContextManager JS ERROR: \(String(describing: value)) \(moreInfo)")
		}
		return context
	}
	
	/// Load the source for the parser
	/// - Parameter jsContext: the context to load the source in.
	private func loadSource(jsContext: JSContext?) throws {
		
		guard let jsContext else {
			throw JSContextManagerError.noJSContext
		}
		
		guard let parserPath = Bundle.module.path(forResource: "mgo-org-search-api.iife", ofType: "js") else {
			logError("JSContextManager: The parser file could not be found")
			throw JSContextManagerError.parserNotFound
		}
		
		// Connect javascript console.log to our console
		let logHandler: @convention(block) (String) -> Void = { string in
			logDebug(string)
		}
		jsContext["console"]?["log"] = logHandler
		
		do {
			let sourceContents = try String(contentsOfFile: parserPath)
			jsContext.evaluateScript(sourceContents)
		} catch {
			logError(error.localizedDescription)
			throw JSContextManagerError.parserNotFound
		}
	}
	
	func createIndex() async throws {
		
		// Ensure JS context is initialized
		try ensureInitialized()
		
		if #available(iOS 16.0, *) {
			let clock = ContinuousClock()
			
			guard let providersPath = Bundle.module.path(forResource: "test-organizations", ofType: "json") else {
				logError("JSContextManager: The organizations file could not be found")
				throw JSContextManagerError.invalidInput
			}
			
			var input: Data?
			
			let loading = try clock.measure {
				// Load the input JSON (providers) as Data
				input = try Data(
					contentsOf: URL(fileURLWithPath: providersPath),
					options: .mappedIfSafe
				)
			}
			logDebug("OrganizationSearch Loading organizations: \(loading)")
			
			guard let input else { return }
			
			let indexing = try await clock.measure {
				_ = try await callJSMethodAsync(named: ParseMethod.index.rawValue, with: input)
			}
			logDebug("OrganizationSearch indexing: \(indexing)")
			providersHaveBeenIndexed = true
		}
	}
	
	// MARK: Private helpers
	
	/// Invoke a JavaScript method synchronously and return its `JSValue`.
	///
	/// This function looks up the configured JavaScript namespace (`JSContextManager.nameSpace`),
	/// converts the provided `Data` to a UTF-8 `String` argument, and invokes the specified
	/// method by name. It returns the raw `JSValue` produced by JavaScript.
	///
	/// Notes:
	/// - When unit testing (`--unittesting` is present), the JS source is reloaded on each call.
	/// - This function does not await Promises; it simply returns the immediate `JSValue`.
	///   Use `callJSMethodAsync` to bridge and await Promise results.
	///
	/// - Parameters:
	///   - methodName: The name of the JavaScript function to invoke within the namespace.
	///   - input: A UTF-8 encoded JSON payload passed to the JS function as a single string argument.
	/// - Returns: The raw `JSValue` returned by the JavaScript invocation.
	/// - Throws:
	///   - `JSContextManagerError.noJSContext` when a JS context is unavailable.
	///   - `JSContextManagerError.invalidNameSpace` if the namespace cannot be found.
	///   - `JSContextManagerError.invalidInput` if the input cannot be converted to a UTF-8 string.
	///   - `JSContextManagerError.noResult` if the invocation yields no value.
	private func callJSMethod(
		named methodName: String,
		with input: Data
	) throws -> JSValue {
		
		// Step 1: Confirm existing JS context
		guard let jsContext else {
			logError("JSContextManager: Could not create JS Context")
			throw JSContextManagerError.noJSContext
		}
		
		// Step 2: Lookup namespace
		guard let nameSpace = jsContext.objectForKeyedSubscript(JSContextManager.nameSpace) else {
			throw JSContextManagerError.invalidNameSpace
		}
		
		// Step 3: Prepare argument string
		guard let inputString = String(data: input, encoding: .utf8) else { throw JSContextManagerError.invalidInput }
		let arguments: [Any] = [inputString]
		
		// Step 4: Invoke by method name
		guard let value = nameSpace.invokeMethod(methodName, withArguments: arguments) else {
			logError("Failed to invoke \(methodName) on the nameSpace")
			throw JSContextManagerError.noResult
		}
		return value
	}
	
	/// Invoke a JavaScript method and await its result, bridging Promises to Swift.
	///
	/// This function calls `callJSMethod` to obtain the initial `JSValue`. If the value exposes
	/// `then`/`catch`, it is treated as a Promise and bridged into Swift using a continuation,
	/// resuming with either the resolved value or an error. Non-Promise values are immediately
	/// converted via `JSValue.toObject()` and returned as `Any`.
	///
	/// Threading:
	/// - Continuation callbacks run on the actor's executor (same thread as the `JSContext`),
	///   and the resolved value is wrapped as `UncheckedSendable` to communicate safety to the compiler.
	///
	/// - Parameters:
	///   - methodName: The name of the JavaScript function to invoke within the namespace.
	///   - input: A UTF-8 encoded JSON payload passed to the JS function as a single string argument.
	/// - Returns: The bridged JavaScript result as `Any` (e.g., `String`, `NSNumber`, `[Any]`, `[String: Any]`).
	/// - Throws:
	///   - `JSContextManagerError.noJSContext` when a JS context is unavailable.
	///   - `JSContextManagerError.invalidNameSpace` or `JSContextManagerError.invalidInput` from `callJSMethod`.
	///   - `JSContextManagerError.noResult` if the Promise is rejected or no value is produced.
	private func callJSMethodAsync(
		named methodName: String,
		with input: Data
	) async throws -> Any? {
		
		// Invoke synchronously to get the initial JSValue (which may be a Promise)
		let value = try callJSMethod(named: methodName, with: input)
		
		// If it's not a Promise (no then/catch), convert to object and return
		if !(value.hasProperty("then") && value.hasProperty("catch")) {
			return value.toObject()
		}
		
		// Await the Promise by bridging then/catch to a Swift continuation
		// Note: The callbacks execute synchronously on the same thread as the JSContext (the actor's thread),
		// so there's no actual data race. We use UncheckedSendable to communicate this to the compiler.
		return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any?, Error>) in
			guard let jsContext else {
				continuation.resume(throwing: JSContextManagerError.noJSContext)
				return
			}
			var resumed = false
			let resolveBlock: @convention(block) (JSValue) -> Void = { resolved in
				if !resumed {
					resumed = true
					// Extract the data from JSValue and wrap in UncheckedSendable
					// This is safe because the callback executes on the actor's executor
					let result = UncheckedSendable(resolved.toObject())
					continuation.resume(returning: result.value)
				}
			}
			let rejectBlock: @convention(block) (JSValue) -> Void = { error in
				let message = error.toString() ?? "Unknown JS error"
				logWarning("JSContextManager: Promise rejected: \(message)")
				if !resumed {
					resumed = true
					continuation.resume(throwing: JSContextManagerError.noResult)
				}
			}
			let resolve = JSValue(object: resolveBlock, in: jsContext)
			let reject = JSValue(object: rejectBlock, in: jsContext)
			_ = value.invokeMethod("then", withArguments: [resolve as Any])
			_ = value.invokeMethod("catch", withArguments: [reject as Any])
		}
	}
	
	/// Search for all the healthcare organizations with this term
	/// - Parameters:
	///   - searchTerm: the search term
	/// - Returns: An (empty) array of Healthcare Organizations
	func searchHealthcareOrganizations(_ searchTerm: String) async throws -> SearchResults? {
		
		var response: SearchResults?
		
		// Ensure JS context is initialized
		try ensureInitialized()
		
		guard providersHaveBeenIndexed else {
			throw JSContextManagerError.noIndex
		}
		
		if let result = try await callJSMethodAsync(
			named: ParseMethod.search.rawValue,
			with: Data(searchTerm.utf8)
		) {
			response = try decodeSearchResults(from: result)
		}
		return response
	}
	
	/// Decode a JavaScript-bridged result into `SearchResults`.
	///
	/// This method accepts the `Any` value produced by `JSValue.toObject()` (or by the
	/// async bridge in `callJSMethodAsync`) and converts it into a strongly-typed
	/// `SearchResults` instance.
	///
	/// It supports two common shapes returned from JavaScript:
	/// - A JSON string (e.g. `JSON.stringify(results)`), which is decoded directly.
	/// - A bridged Foundation object (e.g. `[String: Any]` / `[Any]`), which is first
	///   re-serialized using `JSONSerialization` and then decoded.
	///
	/// - Parameter any: The bridged JavaScript value (`String`, dictionary/array, etc.).
	/// - Returns: A decoded `SearchResults` instance when the payload matches the expected schema.
	/// - Throws: `JSContextManagerError.invalidInput` if the object cannot be represented as
	///   valid JSON, or any decoding error from `JSONDecoder` when the structure does not match
	///   `SearchResults`.
	private func decodeSearchResults(from any: Any) throws -> SearchResults {
		
		// String
		if let jsonString = any as? String {
			return try JSONDecoder().decode(
				SearchResults.self,
				from: Data(jsonString.utf8)
			)
		}
		
		// Dictionary
		guard JSONSerialization.isValidJSONObject(any) else {
			throw JSContextManagerError.invalidInput
		}
		let data = try JSONSerialization.data(
			withJSONObject: any,
			options: []
		)
		return try JSONDecoder().decode(SearchResults.self, from: data)
	}
}

extension JSContext {
	
	subscript(_ key: NSString) -> JSValue? {
		return objectForKeyedSubscript(key)
	}
	
	subscript(_ key: NSString) -> Any? {
		get { return objectForKeyedSubscript(key) }
		set { setObject(newValue, forKeyedSubscript: key) }
	}
}

extension JSValue {
	subscript(_ key: NSString) -> JSValue? {
		return objectForKeyedSubscript(key)
	}
	
	subscript(_ key: NSString) -> Any? {
		get { return objectForKeyedSubscript(key) }
		set { setObject(newValue, forKeyedSubscript: key) }
	}
}

/// Wrapper to mark values as Sendable when we know they're safe but the compiler can't verify
private struct UncheckedSendable<T>: @unchecked Sendable {
	
	let value: T
	
	init(_ value: T) {
		self.value = value
	}
}
