/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import JavaScriptCore
import MGODebug

/// Parse FHIR data
public class FHIRParser {
	
	/// The namespace used in the JavaScript context
	public static let nameSpace = "MgoFhirData"
	
	/// the JavaScript Context
	private var jsContext: JSContext?
	
	/// Create a JS backed FHIR Parser
	public init() {
		
		jsContext = createContext()
		if !ProcessInfo.processInfo.arguments.contains("--unittesting") {
			
			try? loadSource(jsContext: jsContext)
		}
	}
	
	/// What version of the shared core do we use?
	/// - Returns: the version
	public func getVersion() throws -> String {
		
		guard let parserPath = Bundle.module.path(forResource: "version", ofType: "json") else {
			logError("FHIRParser: The parser file could not be found")
			throw FHIRParserError.parserNotFound
		}
		
		let sourceContents = try String(contentsOfFile: parserPath)
		return sourceContents
	}
	
	/// Create the JavaScript Context
	/// - Returns: the JavaScript Context
	private func createContext() -> JSContext? {
		
		let context = JSContext()
		context?.exceptionHandler = { (ctx: JSContext!, value: JSValue!) in
			// type of String
			let stackTrace = value.objectForKeyedSubscript("stack").toString()
			// type of Number
			let lineNumber = value.objectForKeyedSubscript("line")
			// type of Number
			let column = value.objectForKeyedSubscript("column")
			let moreInfo = "in method \(String(describing: stackTrace)) Line number in file: \(String(describing: lineNumber)), column: \(String(describing: column))"
			logError("FHIRParser JS ERROR: \(String(describing: value)) \(moreInfo)")
		}
		return context
	}
	
	/// Load the source for the parser
	/// - Parameter jsContext: the context to load the source in.
	private func loadSource(jsContext: JSContext?) throws {
		
		guard let jsContext else {
			throw FHIRParserError.noJSContext
		}
		
		guard let parserPath = Bundle.module.path(forResource: "mgo-fhir-data.iife", ofType: "js") else {
			logError("FHIRParser: The parser file could not be found")
			throw FHIRParserError.parserNotFound
		}
		
		do {
			let sourceContents = try String(contentsOfFile: parserPath)
			jsContext.evaluateScript(sourceContents)
		} catch {
			logError(error.localizedDescription)
			throw FHIRParserError.parserNotFound
		}
	}
	
	/// getBundleResourcesJson, i.e. split the incoming FHIR Bundle into separate FHIR Resources.
	/// - Parameter bundle: The bundle json from the DVA (as Data)
	/// - Returns: Array of FHIR resources.
	public func splitBundleIntoResources(_ bundle: Data) -> [Data] {
		
		do {
			let resourcesJSValue = try callJSMethod(.bundle, with: bundle)
			
			guard let resourceString = resourcesJSValue.toString(),
				  resourceString.hasSuffix("]"),
				  resourceString.hasPrefix("[") else {
				throw FHIRParserError.noResult
			}
			
			let result = String(resourceString.dropFirst().dropLast())
				.replacingOccurrences(of: "},{\"res", with: "}💊{\"res")
				.split(separator: "💊")
				.map { Data(String($0).utf8) }
			return result
		} catch {
			logError(error.localizedDescription)
		}
		return []
	}
	
	/// parseResourceJson, i.e. transform the incoming FHIR Resource into a Zib object
	/// - Parameter fhirResource: resource to parse
	/// - Parameter fhirVersion: the FHIR version of the expected resource, defaults to `R3`
	/// - Returns: Zib as data
	public func transformFHIRResourceIntoMGOResource(_ fhirResource: Data, fhirVersion: String = "R3") -> Data? {
		
		do {
			let resourcesJSValue = try callJSMethod(.resource, with: fhirResource, fhirVersion: fhirVersion)
			return Data(resourcesJSValue.toString().utf8)
			
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
	
	/// get the details for a resource, i.e. transform a Zib object into a details HealthUISchema
	/// - Parameter resource: the zib / mgo resource
	/// - Returns: Generated HealthUISchema
	public func getDetails(_ resource: Data) -> HealthUISchema? {
		
		return getSchema(.details, resource: resource)
	}
	
	/// get the summary for a resource, i.e. transform a Zib object into a summary HealthUISchema
	/// - Parameter resource: the zib / mgo resource
	/// - Returns: Generated HealthUISchema
	public func getSummary(_ resource: Data) -> HealthUISchema? {
		
		return getSchema(.summary, resource: resource)
	}
	
	// MARK: Private helpers
	
	/// Call a javascript method with the input data
	/// - Parameters:
	///   - method: the method in javascript to be called
	///   - input: the input for that method
	///   - fhirVersion: the FHIR version of the expected resource,
	/// - Returns: the result of invoking that method
	private func callJSMethod(_ method: ParseMethod, with input: Data, fhirVersion: String? = nil) throws -> JSValue {
		
		// Step 1A: Confirm existing JS context
		guard let jsContext else {
			logError("FHIRParser: Could not create JS Context")
			throw FHIRParserError.noJSContext
		}
		
		// Step 1B: When testing, do load the source every time.
		if ProcessInfo.processInfo.arguments.contains("--unittesting") {
			try? loadSource(jsContext: jsContext)
		}
		
		// Step 2: Search for the MgoFhirData namespace
		guard let nameSpace = jsContext.objectForKeyedSubscript(FHIRParser.nameSpace) else {
			throw FHIRParserError.invalidNameSpace
		}
		
		// Step 3: Stringify the input (json)
		guard let inputString = String(data: input, encoding: .utf8) else { throw FHIRParserError.invalidInput }
		var arguments = [inputString]
		if let fhirVersion {
			arguments.append("{\"fhirVersion\": \"\(fhirVersion)\"}")
		}
		
		// Step 4: call the desired method (getBundleResourcesJson etc) on the namespace with the input
		guard let resourcesJSValue = nameSpace.invokeMethod(method.rawValue, withArguments: arguments) else {
			logError("Failed to invoke \(method) on the nameSpace")
			throw FHIRParserError.noResult
		}
		
		// Step 5: return the outcome of the call
		return resourcesJSValue
	}
	
	/// get the schema for a resource, i.e. transform a Zib object into a UISchema
	/// - Parameter method: the javascript method to be used for this call
	/// - Parameter resource: the zib / mgo resource
	/// - Returns: Generated UISchema
	private func getSchema(_ method: ParseMethod, resource: Data) -> HealthUISchema? {
		
		do {
			let resourcesJSValue = try callJSMethod(method, with: resource)
			if let object = resourcesJSValue.toString() {
				let schema = try HealthUISchema(object)
				return schema
			}
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
}
