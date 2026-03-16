/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import JavaScriptCore
import MGODebug

/// A parser that transforms raw FHIR data into Health and Care Information
/// Models (HCIMs) and then into UI-ready representations using a shared
/// JavaScript core.
///
/// `HCIMParser` wraps a `JSContext` that evaluates `mgo-hcim-api.iife.js`
/// — the shared JavaScript library responsible for all FHIR-to-HCIM
/// conversions. The typical call sequence is:
///
/// 1. ``splitBundleIntoResources(_:)`` — split a FHIR Bundle into
///    individual FHIR resources.
/// 2. ``transformFHIRResourceIntoHCIM(_:fhirVersion:)`` — convert each
///    resource into a HCIM object.
/// 3. ``getCard(_:organizationName:)``,
///    ``getDetails(_:organizationName:)``, or
///    ``getSummary(_:organizationName:)`` — convert the HCIM into a UI
///    schema.
///
/// All public methods return `nil` (and log an error) rather than throwing
/// when the JavaScript layer fails, so callers can handle individual parse
/// failures without crashing.
nonisolated public class HCIMParser {
	
	/// The JavaScript namespace under which the HCIM API methods are registered.
	public static let nameSpace = "HcimApi"
	
	/// The JavaScript execution context that hosts the shared HCIM core.
	private var jsContext: JSContext?
	
	/// Creates a new `HCIMParser` and loads the shared JavaScript core into
	/// its context.
	///
	/// During unit testing (detected via the `--unittesting` launch argument)
	/// the JS source is intentionally not pre-loaded here; it is instead
	/// loaded lazily on each call to
	/// ``callJSMethod(_:with:fhirVersion:organizationName:)`` to ensure a
	/// clean state per test.
	public init() {
		
		jsContext = createContext()
		if !ProcessInfo.processInfo.arguments.contains("--unittesting") {
			
			try? loadSource(jsContext: jsContext)
		}
	}
	
	/// Returns the version of the bundled HCIM shared core.
	///
	/// The version is read from the `version.json` resource bundled with
	/// the module.
	///
	/// - Throws: ``HCIMVersion/Error/noResource`` if the version file cannot
	///   be located in the bundle.
	/// - Returns: The parsed ``HCIMVersion``.
	public func getVersion() throws -> HCIMVersion {
		
		guard let parserPath = Bundle.module.path(forResource: "version", ofType: "json") else {
			logError("HCIMParser: The version file could not be found")
			throw HCIMVersion.Error.noResource
		}
		
		return try HCIMVersion(String(contentsOfFile: parserPath))
	}
	
	/// Creates and configures a `JSContext`, installing an exception handler
	/// that logs JavaScript errors (including stack trace, line number, and
	/// column) via `logError`.
	///
	/// - Returns: A configured `JSContext`, or `nil` if the system could not
	///   allocate one.
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
			logError("HCIMParser JS ERROR: \(String(describing: value)) \(moreInfo)")
		}
		return context
	}
	
	/// Loads and evaluates the bundled HCIM JavaScript source into the given
	/// context.
	///
	/// - Parameter jsContext: The `JSContext` to evaluate the source in.
	/// - Throws: ``HCIMParserError/noJSContext`` if `jsContext` is `nil`,
	///   or ``HCIMParserError/parserNotFound`` if the JS file is missing
	///   from the bundle or cannot be read.
	private func loadSource(jsContext: JSContext?) throws {
		
		guard let jsContext else {
			throw HCIMParserError.noJSContext
		}
		
		guard let parserPath = Bundle.module.path(
			forResource: "mgo-hcim-api.iife",
			ofType: "js"
		) else {
			logError("HCIMParser: The parser file could not be found")
			throw HCIMParserError.parserNotFound
		}
		
		do {
			let sourceContents = try String(contentsOfFile: parserPath)
			jsContext.evaluateScript(sourceContents)
		} catch {
			logError(error.localizedDescription)
			throw HCIMParserError.parserNotFound
		}
	}
	
	/// Splits a FHIR Bundle into its individual FHIR resources.
	///
	/// Invokes the `.splitBundle` JavaScript method on the HCIM core, which
	/// returns a JSON array string. Because the output is a comma-separated
	/// string rather than a proper JSON array of objects, the result is
	/// split on `},{` boundaries using a pill emoji (💊) as an intermediate
	/// delimiter before being mapped to `Data`.
	///
	/// - Parameter bundle: The raw FHIR Bundle JSON received from the DVA,
	///   as `Data`.
	/// - Returns: An array of individual FHIR resource payloads as `Data`,
	///   or an empty array if the JS call fails or returns an unexpected
	///   format.
	public func splitBundleIntoResources(_ bundle: Data) -> [Data] {
		
		do {
			let resourcesJSValue = try callJSMethod(.splitBundle, with: bundle)
			
			guard let resourceString = resourcesJSValue.toString(),
				  resourceString.hasSuffix("]"),
				  resourceString.hasPrefix("[") else {
				throw HCIMParserError.noResult
			}
			/*
			 We need to do some magic, as the output of the previous call
			 is a comma separated string. We still need to split that into
			 an array of strings and map it to Data
			*/
			return String(resourceString.dropFirst().dropLast())
				.replacingOccurrences(of: "},{\"res", with: "}💊{\"res")
				.split(separator: "💊")
				.map { Data(String($0).utf8) }
		} catch {
			logError(error.localizedDescription)
		}
		return []
	}
	
	/// Transforms a raw FHIR resource into a HCIM object.
	///
	/// Invokes the `.resource` JavaScript method on the HCIM core, passing
	/// the serialised FHIR resource and the FHIR version hint. The result
	/// is the HCIM JSON representation that can be passed to
	/// ``getCard(_:organizationName:)``,
	/// ``getDetails(_:organizationName:)``, or
	/// ``getSummary(_:organizationName:)``.
	///
	/// - Parameters:
	///   - fhirResource: The raw FHIR resource JSON, as `Data`.
	///   - fhirVersion: The FHIR version of the resource. Defaults to `"R3"`.
	/// - Returns: The HCIM object as `Data`, or `nil` if the JS call fails.
	public func transformFHIRResourceIntoHCIM(
		_ fhirResource: Data,
		fhirVersion: String = "R3"
	) -> Data? {
		
		do {
			let resourcesJSValue = try callJSMethod(
				.resource,
				with: fhirResource,
				fhirVersion: fhirVersion
			)
			return Data(resourcesJSValue.toString().utf8)
			
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
	
	/// Transforms a HCIM resource into an `HcimCardDetails` object suitable
	/// for display in a card UI.
	///
	/// This method invokes the `.card` JavaScript method on the shared HCIM
	/// core, passing the serialised HCIM resource and an optional
	/// organisation name. The JavaScript result is deserialised into an
	/// `HcimCardDetails` value.
	///
	/// Returns `nil` and logs an error if:
	/// - the JavaScript context is unavailable,
	/// - the JS method invocation fails, or
	/// - the returned JSON cannot be decoded into `HcimCardDetails`.
	///
	/// - Parameters:
	///   - resource: The HCIM resource as raw JSON data, typically produced
	///     by ``transformFHIRResourceIntoHCIM(_:fhirVersion:)``.
	///   - organizationName: The display name of the healthcare organisation,
	///     passed to the JavaScript core so it can be included in the card
	///     output. Pass `nil` when unavailable.
	/// - Returns: The decoded `HcimCardDetails`, or `nil` if parsing fails.
	public func getCard(
		_ resource: Data,
		organizationName: String?
	) -> HcimCardDetails? {
		
		do {
			let resourcesJSValue = try callJSMethod(
				.card,
				with: resource,
				organizationName: organizationName
			)
			if let object = resourcesJSValue.toString() {
				return try HcimCardDetails(object)
			}
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
	
	/// Transforms a HCIM resource into a detailed ``HealthUISchema`` for the
	/// full detail view.
	///
	/// Delegates to ``getSchema(_:resource:organizationName:)`` using the
	/// `.details` JS method.
	///
	/// - Parameters:
	///   - resource: The HCIM resource as raw JSON data, typically produced
	///     by ``transformFHIRResourceIntoHCIM(_:fhirVersion:)``.
	///   - organizationName: The display name of the healthcare organisation,
	///     or `nil` if unavailable.
	/// - Returns: The decoded ``HealthUISchema``, or `nil` if parsing fails.
	public func getDetails(
		_ resource: Data,
		organizationName: String?
	) -> HealthUISchema? {
		
		return getSchema(
			.details,
			resource: resource,
			organizationName: organizationName
		)
	}
	
	/// Transforms a HCIM resource into a summary ``HealthUISchema`` for list
	/// or card views.
	///
	/// Delegates to ``getSchema(_:resource:organizationName:)`` using the
	/// `.summary` JS method.
	///
	/// - Parameters:
	///   - resource: The HCIM resource as raw JSON data, typically produced
	///     by ``transformFHIRResourceIntoHCIM(_:fhirVersion:)``.
	///   - organizationName: The display name of the healthcare organisation,
	///     or `nil` if unavailable.
	/// - Returns: The decoded ``HealthUISchema``, or `nil` if parsing fails.
	public func getSummary(
		_ resource: Data,
		organizationName: String?
	) -> HealthUISchema? {
		
		return getSchema(
			.summary,
			resource: resource,
			organizationName: organizationName
		)
	}
	
	// MARK: Private helpers
	
	/// Invokes a named method on the `HcimApi` JavaScript namespace with the
	/// given input data.
	///
	/// Arguments are built as a JSON string array:
	/// 1. The UTF-8 string representation of `input`.
	/// 2. `{"fhirVersion": "<version>"}` — appended only when `fhirVersion`
	///    is non-`nil`.
	/// 3. `{"organization": {"name": "<name>"}}` — appended only when
	///    `organizationName` is non-`nil`.
	///
	/// - Parameters:
	///   - method: The ``ParseMethod`` identifying which JS function to call.
	///   - input: The payload to pass as the first argument, as raw JSON
	///     `Data`.
	///   - fhirVersion: An optional FHIR version hint forwarded to the JS
	///     core.
	///   - organizationName: An optional organisation name forwarded to the
	///     JS core.
	/// - Throws: ``HCIMParserError/noJSContext`` if the context is
	///   unavailable,
	///   ``HCIMParserError/invalidNameSpace`` if `HcimApi` is not defined
	///   in the context,
	///   ``HCIMParserError/invalidInput`` if `input` cannot be decoded to a
	///   UTF-8 string,
	///   or ``HCIMParserError/noResult`` if the JS method returns `nil`.
	/// - Returns: The raw `JSValue` returned by the JavaScript method.
	private func callJSMethod(
		_ method: ParseMethod,
		with input: Data,
		fhirVersion: String? = nil,
		organizationName: String? = nil
	) throws -> JSValue {
		
		// Step 1A: Confirm existing JS context
		guard let jsContext else {
			logError("HCIMParser: Could not create JS Context")
			
			throw HCIMParserError.noJSContext
		}
		
		// Step 1B: When testing, do load the source every time.
		if ProcessInfo.processInfo.arguments.contains("--unittesting") {
			try? loadSource(jsContext: jsContext)
		}
		
		// Step 2: Search for the MgoFhirData namespace
		guard let nameSpace = jsContext.objectForKeyedSubscript(
			HCIMParser.nameSpace
		) else {
			throw HCIMParserError.invalidNameSpace
		}
		
		// Step 3: Stringify the input (json)
		guard let inputString = String(data: input, encoding: .utf8) else { throw HCIMParserError.invalidInput }
		var arguments = [inputString]
		if let fhirVersion {
			arguments.append("{\"fhirVersion\": \"\(fhirVersion)\"}")
		}
		if let organizationName {
			arguments.append("{\"organization\": { \"name\" :\"\(organizationName)\"}}")
		}
		
		// Step 4: call the desired method (getBundleResourcesJson etc)
		// on the namespace with the input
		guard let resourcesJSValue = nameSpace.invokeMethod(
			method.rawValue,
			withArguments: arguments
		) else {
			logError("Failed to invoke \(method) on the nameSpace")
			throw HCIMParserError.noResult
		}
		
		// Step 5: return the outcome of the call
		return resourcesJSValue
	}
	
	/// Shared implementation for ``getDetails(_:organizationName:)`` and
	/// ``getSummary(_:organizationName:)``.
	///
	/// Invokes the given JS `method` and attempts to decode the result into
	/// a ``HealthUISchema``. Returns `nil` and logs an error on any failure.
	///
	/// - Parameters:
	///   - method: The ``ParseMethod`` to invoke (`.details` or `.summary`).
	///   - resource: The HCIM resource as raw JSON data.
	///   - organizationName: The display name of the healthcare organisation, or `nil`.
	/// - Returns: The decoded ``HealthUISchema``, or `nil` if parsing fails.
	private func getSchema(
		_ method: ParseMethod,
		resource: Data,
		organizationName: String?
	) -> HealthUISchema? {
		
		do {
			let resourcesJSValue = try callJSMethod(
				method,
				with: resource,
				organizationName: organizationName
			)
			if let object = resourcesJSValue.toString() {
				return try HealthUISchema(object)
			}
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
}
