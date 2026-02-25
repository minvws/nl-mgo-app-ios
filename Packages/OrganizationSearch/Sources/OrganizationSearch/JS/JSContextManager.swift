/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import JavaScriptCore
import MGODebug

/// Actor-isolated manager for executing JavaScript-based organization search operations.
///
/// `JSContextManager` provides a thread-safe interface for interacting with a JavaScript search engine
/// via JavaScriptCore. It handles initialization, indexing of organization data, and search queries
/// while ensuring all JavaScript operations occur on the same thread where the `JSContext` was created.
///
/// Usage:
/// ```swift
/// let manager = JSContextManager()
/// try await manager.createIndex()
/// let results = try await manager.searchHealthcareOrganizations("hospital")
/// ```
///
/// Threading:
/// - All methods are isolated to the actor, guaranteeing serial execution.
/// - The underlying `JSContext` is accessed exclusively from the actor's executor thread.
///
/// Testability:
/// - Pass a custom `MeasurableClock` to `init(clock:)` to control or observe timing behaviour in tests.
/// - `DateMeasurer` can be injected to exercise the iOS 15 timing path on any OS version.
actor JSContextManager {
	
	/// The namespace used in the JavaScript context to access the search API.
	static let nameSpace = "OrgSearchApi"
	
	/// The JavaScript execution context. Lazily initialized on first use.
	private var jsContext: JSContext?
	
	/// Indicates whether the organization data has been indexed and is ready for searching.
	private var providersHaveBeenIndexed: Bool = false
	
	/// Tracks whether the JavaScript context has been initialized with the search library.
	private var isInitialized: Bool = false
	
	/// The clock used to measure loading and indexing durations.
	private let clock: any MeasurableClock
	
	/// Create a new `JSContextManager`.
	///
	/// The JavaScript context is initialised lazily on first use, so this call is cheap.
	///
	/// - Parameter clock: The clock used to measure loading and indexing durations.
	///   Defaults to `ContinuousClockMeasurer` on iOS 16+ and `DateMeasurer` on iOS 15.
	///   Inject a custom value in tests to observe or control timing behaviour.
	init(clock: (any MeasurableClock)? = nil) {
		// Actor initializers are non-isolated, so we can't call actor-isolated methods here
		// Initialization will be done lazily on first use
		self.clock = clock ?? makeMeasurableClock()
	}
	
	/// Ensure the JS context is initialized (called before any JS operations).
	///
	/// This method performs lazy initialization of the JavaScript environment, creating the context
	/// and loading the search library only when first needed. Subsequent calls are no-ops.
	///
	/// - Throws: `JSContextManagerError` if context creation or source loading fails.
	private func ensureInitialized() throws {
		guard !isInitialized else { return }
		
		jsContext = createContext()
		try loadSource(jsContext: jsContext)
		
		isInitialized = true
	}
	
	/// Create and configure a new JavaScript execution context.
	///
	/// Sets up exception handling to capture and log JavaScript runtime errors with stack traces.
	///
	/// - Returns: A configured `JSContext` instance, or `nil` if creation fails.
	private func createContext() -> JSContext? {
		
		let context = JSContext()
		// Configure exception handler to capture JavaScript errors
		context?.exceptionHandler = { (ctx: JSContext!, value: JSValue!) in
			let stackTrace = value.objectForKeyedSubscript("stack").toString()
			let lineNumber = value.objectForKeyedSubscript("line")
			let column = value.objectForKeyedSubscript("column")
			let moreInfo = "in method \(String(describing: stackTrace)) Line number in file: \(String(describing: lineNumber)), column: \(String(describing: column))"
			logError("JSContextManager JS ERROR: \(String(describing: value)) \(moreInfo)")
		}
		return context
	}
	
	/// Load the JavaScript search library into the execution context.
	///
	/// Locates and evaluates the bundled JavaScript file (`mgo-org-search-api.iife.js`),
	/// making the search API available within the configured namespace. Also bridges
	/// JavaScript `console.log` calls to Swift's debug logging.
	///
	/// - Parameter jsContext: The context to load the source into.
	/// - Throws:
	///   - `JSContextManagerError.noJSContext` if the context is `nil`.
	///   - `JSContextManagerError.parserNotFound` if the JavaScript file cannot be found or loaded.
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
	
	/// Create a searchable index from organization data.
	///
	/// This method loads organization data from a bundled JSON file and builds a search index
	/// using the JavaScript search library. The operation is asynchronous and logs performance
	/// metrics for both the file-loading and the JavaScript indexing steps using the injected
	/// `MeasurableClock`.
	///
	/// The data source varies based on the runtime environment:
	/// - Test mode: Uses `test-organizations.json` (smaller dataset for faster tests)
	/// - Production mode: Uses `organizations.json` (full dataset)
	///
	/// Must be called before `searchHealthcareOrganizations(_:)` can be used.
	///
	/// - Throws:
	///   - `JSContextManagerError.invalidInput` if the organization data file cannot be found.
	///   - `JSContextManagerError` variants from JavaScript method invocation.
	///   - File I/O errors when loading organization data.
	///
	/// - Note: Performance metrics are logged to help monitor indexing times across different devices.
	func createIndex() async throws {
		
		// Ensure JS context is initialized
		try ensureInitialized()
		
		// Determine which data file to use based on runtime environment
		let fileName = /*isRunningTests() ? "test-organizations" :*/ "benchmark-organizations"
		
		guard let providersPath = Bundle.module.path(
			forResource: fileName,
			ofType: "json"
		) else {
			logError("JSContextManager: The organizations file could not be found")
			throw JSContextManagerError.invalidInput
		}
		
		// Measure loading time
		let loadStart = clock.now()
		let input = try Data(
			contentsOf: URL(fileURLWithPath: providersPath),
			options: .mappedIfSafe
		)
		logDebug("OrganizationSearch Loading organizations: \(clock.elapsed(since: loadStart))")
		
		// Measure indexing time
		let indexStart = clock.now()
		_ = try await callJSMethodAsync(named: ParseMethod.index.rawValue, with: input)
		logDebug("OrganizationSearch indexing: \(clock.elapsed(since: indexStart))")
		providersHaveBeenIndexed = true
	}
	
	// MARK: Private helpers
	
	/// Invoke a JavaScript method synchronously and return its `JSValue`.
	///
	/// This function looks up the configured JavaScript namespace (`JSContextManager.nameSpace`),
	/// converts the provided `Data` to a UTF-8 `String` argument, and invokes the specified
	/// method by name. It returns the raw `JSValue` produced by JavaScript.
	///
	/// Notes:
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
	
	/// Search for healthcare organizations matching the given search term.
	///
	/// Executes a search query against the indexed organization data using the JavaScript search library.
	/// The search index must be created via `createIndex()` before calling this method.
	///
	/// - Parameter searchTerm: The search query string to match against organization names and attributes.
	/// - Returns: A `SearchResults` object containing matching organizations, or `nil` if the search yields no results.
	/// - Throws:
	///   - `JSContextManagerError.noIndex` if `createIndex()` has not been called yet.
	///   - `JSContextManagerError` variants from JavaScript method invocation or result decoding.
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
	
	/// Detect if the code is running in a test environment.
	///
	/// Uses the presence of `XCTestCase` class to determine if running within a test bundle.
	///
	/// - Returns: `true` if running tests, `false` otherwise.
	private func isRunningTests() -> Bool {
		return NSClassFromString("XCTestCase") != nil
	}
}

// MARK: - Convenience Extensions

extension JSContext {
	
	/// Subscript accessor for retrieving `JSValue` objects by key.
	subscript(_ key: NSString) -> JSValue? {
		return objectForKeyedSubscript(key)
	}
	
	/// Subscript accessor for getting and setting JavaScript values by key.
	subscript(_ key: NSString) -> Any? {
		get { return objectForKeyedSubscript(key) }
		set { setObject(newValue, forKeyedSubscript: key) }
	}
}

extension JSValue {
	
	/// Subscript accessor for retrieving nested `JSValue` objects by key.
	subscript(_ key: NSString) -> JSValue? {
		return objectForKeyedSubscript(key)
	}
	
	/// Subscript accessor for getting and setting nested JavaScript values by key.
	subscript(_ key: NSString) -> Any? {
		get { return objectForKeyedSubscript(key) }
		set { setObject(newValue, forKeyedSubscript: key) }
	}
}

/// Wrapper to mark values as `Sendable` when we know they're safe but the compiler can't verify.
///
/// This is used to bridge JavaScript values across concurrency domains. The wrapped values are safe
/// because they're extracted on the actor's executor and immediately transferred via the continuation.
private struct UncheckedSendable<T>: @unchecked Sendable {
	
	/// The wrapped value.
	let value: T
	
	/// Create a new `UncheckedSendable` wrapper.
	/// - Parameter value: The value to wrap.
	init(_ value: T) {
		self.value = value
	}
}
