/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import FHIRClient
import Foundation
import JavaScriptCore
import Logging
import Zibs

public class FHIRParser {
	
	/// Initializer
	public init() {
		// Empty public initializer, needed for public access
	}
	
	/// Create the JavaScript Context
	/// - Returns: the JavaScript Context
	private func createContext() -> JSContext? {
		
		let jsContext = JSContext()
		jsContext?.exceptionHandler = { (ctx: JSContext!, value: JSValue!) in
			// type of String
			let stacktrace = value.objectForKeyedSubscript("stack").toString()
			// type of Number
			let lineNumber = value.objectForKeyedSubscript("line")
			// type of Number
			let column = value.objectForKeyedSubscript("column")
			let moreInfo = "in method \(String(describing: stacktrace)) Line number in file: \(String(describing: lineNumber)), column: \(String(describing: column))"
			logError("FHIRParser JS ERROR: \(String(describing: value)) \(moreInfo)")
		}
		return jsContext
	}
	
	/// Load the source for the parser
	/// - Parameter jsContext: the context to load the source in.
	private func loadSource(jsContext: JSContext) throws {
		
		guard let parserPath = Bundle.module.path(forResource: "mgo-fhir-data", ofType: "js") else {
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
	/// - Returns: the result of invoking that method
	private func callJSMethod(_ method: String, with input: Data) throws -> JSValue {
		
		guard let jsContext = createContext() else {
			logError("FHIRParser: Could not create JS Context")
			throw FHIRParserError.noJSContext
		}
		
		try loadSource(jsContext: jsContext)
		
		guard let parseFunction = jsContext.objectForKeyedSubscript(method) else {
			logError("FHIRParser: the parser method \(method) could not be found")
			throw FHIRParserError.invalidMethod
		}
		
		let inputString = String(decoding: input, as: UTF8.self)
		
		guard let resourcesJSValue = parseFunction.call(withArguments: [inputString]) else {
			logError("Failed to parse bundle resources")
			throw FHIRParserError.noResult
		}
//		logDebug("\(resourcesJSValue)")
		return resourcesJSValue
	}
	
	/// getBundleResourcesJson, i.e. split the incoming FHIR Bundle into separate Resources.
	/// - Parameter json: The bundle json from the DVP (as Data)
	/// - Returns: Array of STU3 resources. 
	public func getBundleResourcesJson(_ json: Data) -> [Any] {
		
		do {
			let resourcesJSValue = try callJSMethod("getBundleResourcesJson", with: json)
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
	
	// parseResourceJson, i.e. transform the incoming FHIR Resource into a Zib object
	public func parseResourceJson(_ json: Data) -> Data? {
		
		do {
			let resourcesJSValue = try callJSMethod("parseResourceJson", with: json)
			let data = Data(resourcesJSValue.toString().utf8)
			return data
			
		} catch {
			logError(error.localizedDescription)
		}
		return nil
	}
	
	// getUiSchemaJson, i.e. transform a Zib object into a UISchema
	public func getUiSchemaJson(_ json: Data) -> UISchema? {
		
		do {
			let resourcesJSValue = try callJSMethod("getUiSchemaJson", with: json)
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

public enum FHIRParserError: Error, CustomStringConvertible {
	
	case invalidMethod
	case noJSContext
	case noResult
	case parserNotFound
	
	public var description: String {
		switch self {
			case .invalidMethod:
				"This method is invalid."
			case .noJSContext:
				"The JSContext could not be created"
			case .noResult:
				"No result found"
			case .parserNotFound:
				"The source file for the parser was not found."
		}
	}
}
