/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import JavaScriptCore
import MGODebug

/// Parse FHIR data
nonisolated public class HCIMParser {
	
	/// The namespace used in the JavaScript context
	public static let nameSpace = "HcimApi"
	
	/// the JavaScript Context
	private var jsContext: JSContext?
	
	/// Create a JS backed HCIM parser
	public init() {
		
		jsContext = createContext()
		if !ProcessInfo.processInfo.arguments.contains("--unittesting") {
			
			try? loadSource(jsContext: jsContext)
		}
	}
	
	/// What version of the shared core are we running?
	/// - Returns: the version
	public func getVersion() throws -> String {
		
		guard let parserPath = Bundle.module.path(forResource: "version", ofType: "json") else {
			logError("HCIMParser: The parser file could not be found")
			throw HCIMParserError.parserNotFound
		}
		return try String(contentsOfFile: parserPath)
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
			logError("HCIMParser JS ERROR: \(String(describing: value)) \(moreInfo)")
		}
		return context
	}
	
	/// Load the source for the parser
	/// - Parameter jsContext: the context to load the source in.
	private func loadSource(jsContext: JSContext?) throws {
		
		guard let jsContext else {
			throw HCIMParserError.noJSContext
		}
		
		guard let parserPath = Bundle.module.path(forResource: "mgo-hcim-api.iife", ofType: "js") else {
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
	
	/// getBundleResourcesJson, i.e. split the incoming FHIR Bundle into separate FHIR Resources.
	/// - Parameter bundle: The bundle json from the DVA (as Data)
	/// - Returns: Array of FHIR resources.
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
	
	/// parseResourceJson, i.e. transform the incoming FHIR Resource into a HCIM
	/// - Parameter fhirResource: resource to parse
	/// - Parameter fhirVersion: the FHIR version of the expected resource, defaults to `R3`
	/// - Returns: HCIM as data
	public func transformFHIRResourceIntoHCIM(_ fhirResource: Data, fhirVersion: String = "R3") -> Data? {
		
		do {
			let resourcesJSValue = try callJSMethod(.resource, with: fhirResource, fhirVersion: fhirVersion)
			return Data(resourcesJSValue.toString().utf8)
			
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
	
	/// get the details for a resource, i.e. transform a HCIM object into a details HealthUISchema
	/// - Parameter resource: the HCIM resource
	/// - Returns: Generated HealthUISchema
	public func getDetails(_ resource: Data, organizationName: String?) -> HealthUISchema? {
		
		return getSchema(.details, resource: resource, organizationName: organizationName)
	}
	
	/// get the summary for a resource, i.e. transform a HCIM object into a summary HealthUISchema
	/// - Parameter resource: the HCIM resource
	/// - Returns: Generated HealthUISchema
	public func getSummary(_ resource: Data, organizationName: String?) -> HealthUISchema? {
		
		return getSchema(.summary, resource: resource, organizationName: organizationName)
	}
	
	// MARK: Private helpers
	
	/// Call a javascript method with the input data
	/// - Parameters:
	///   - method: the method in javascript to be called
	///   - input: the input for that method
	///   - fhirVersion: the FHIR version of the expected resource,
	///   - organizationName: the name of the organization
	/// - Returns: the result of invoking that method
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
		guard let nameSpace = jsContext.objectForKeyedSubscript(HCIMParser.nameSpace) else {
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
		
		// Step 4: call the desired method (getBundleResourcesJson etc) on the namespace with the input
		guard let resourcesJSValue = nameSpace.invokeMethod(method.rawValue, withArguments: arguments) else {
			logError("Failed to invoke \(method) on the nameSpace")
			throw HCIMParserError.noResult
		}
		
		// Step 5: return the outcome of the call
		return resourcesJSValue
	}
	
	/// get the schema for a resource, i.e. transform a HCIM object into a UISchema
	/// - Parameter method: the javascript method to be used for this call
	/// - Parameter resource: the HCIM resource
	/// - Returns: Generated UISchema
	private func getSchema(_ method: ParseMethod, resource: Data, organizationName: String?) -> HealthUISchema? {
		
		do {
			let resourcesJSValue = try callJSMethod(method, with: resource, organizationName: organizationName)
			if let object = resourcesJSValue.toString() {
				return try HealthUISchema(object)
			}
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
}
