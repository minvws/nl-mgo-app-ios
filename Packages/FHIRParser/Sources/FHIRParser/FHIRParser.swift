/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import JavaScriptCore
import Logging
import Zibs

public class FHIRParser {
	
	public static let nameSpace = "MgoFhirData"
	
	private var jsContext: JSContext?
	
	/// Create a FHIR Parser
	public init() {
		
		jsContext = createContext()
		if !ProcessInfo.processInfo.arguments.contains("--unittesting") {
			
			try? loadSource(jsContext: jsContext)
		}
	}
	
	/// Create the JavaScript Context
	/// - Returns: the JavaScript Context
	private func createContext() -> JSContext? {
		
		let jsContext = JSContext()
		jsContext?.exceptionHandler = { (ctx: JSContext!, value: JSValue!) in
			// type of String
			let stackTrace = value.objectForKeyedSubscript("stack").toString()
			// type of Number
			let lineNumber = value.objectForKeyedSubscript("line")
			// type of Number
			let column = value.objectForKeyedSubscript("column")
			let moreInfo = "in method \(String(describing: stackTrace)) Line number in file: \(String(describing: lineNumber)), column: \(String(describing: column))"
			logError("FHIRParser JS ERROR: \(String(describing: value)) \(moreInfo)")
		}
		return jsContext
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
	
	/// Call a javascript method with the input data
	/// - Parameters:
	///   - method: the method in javascript to be called
	///   - input: the input for that method
	///   - fhirVersion: the FHIR version of the expected resource,
	/// - Returns: the result of invoking that method
	private func callJSMethod(_ method: String, with input: Data, fhirVersion: String? = nil) throws -> JSValue {
		
		// Step 1: Confirm existing JS context
		guard let jsContext else {
			logError("FHIRParser: Could not create JS Context")
			throw FHIRParserError.noJSContext
		}
		
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
			arguments.append(fhirVersion)
		}
		
		// Step 4: call the desired method (getBundleResourcesJson etc) on the namespace with the input
		guard let resourcesJSValue = nameSpace.invokeMethod(method, withArguments: arguments) else {
			logError("Failed to invoke \(method) on the nameSpace")
			throw FHIRParserError.noResult
		}
		
		// Step 5: return the outcome of the call
		return resourcesJSValue
	}
	
	/// getBundleResourcesJson, i.e. split the incoming FHIR Bundle into separate FHIR Resources.
	/// - Parameter bundle: The bundle json from the DVA (as Data)
	/// - Returns: Array of FHIR resources.
	public func splitBundleIntoResources(_ bundle: Data) -> [Any] {
		
		do {
			let resourcesJSValue = try callJSMethod("getBundleResourcesJson", with: bundle)
			let data = Data(resourcesJSValue.toString().utf8)
			
			let json2 = try JSONSerialization.jsonObject(with: data, options: [])
			if let array = json2 as? [Any] {
				return array
			}
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
			let resourcesJSValue = try callJSMethod("getMgoResourceJson", with: fhirResource, fhirVersion: fhirVersion)
			return Data(resourcesJSValue.toString().utf8)
			
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
	
	/// getUiSchemaJson, i.e. transform a Zib object into a UISchema
	/// - Parameter resource: the zib / mgo resource
	/// - Returns: Generated UISchema
	public func getUiSchemaJson(_ resource: Data) -> UISchema? {
		
		do {
			let resourcesJSValue = try callJSMethod("getUiSchemaJson", with: resource)
			if let object = resourcesJSValue.toString() {
				let schema = try UISchema(object)
				return schema
			}
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
}

/// the FHIR parse errors
public enum FHIRParserError: Error {
	
	// The input could not be converted
	case invalidInput
	
	// This method is not available in the JS parser
	case invalidMethod
	
	// This namespace is not available in the JS parser
	case invalidNameSpace
	
	// Failed to initiate a JS Context
	case noJSContext
	
	// There was no output
	case noResult
	
	// The parser was not found at its location
	case parserNotFound
}
