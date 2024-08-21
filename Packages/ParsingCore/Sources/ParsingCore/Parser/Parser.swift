/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import FHIRClient
import FHIRExtensions
import Foundation
import JavaScriptCore
import Logging

public class FHIRParser {
	
	/// path to the shared JS library
	private let parserPath: String?
	
	/// Initializer
	public init() {
		
		parserPath = Bundle.module.path(forResource: "mgo-fhir-data", ofType: "js")
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
	
	/// Prepare the parser with the right source file
	/// - Parameter context: the Javascript Context
	private func prepareParser(context: JSContext) {
		
		guard let parserPath else {
			logError("file not found")
			return
		}
		
		do {
			let sourceContents = try String(contentsOfFile: parserPath)
			context.evaluateScript(sourceContents)
		} catch {
			logError(error.localizedDescription)
		}
	}
	
	// getBundleResourcesJson, i.e. split the incoming FHIR Bundle into separate Resources.
	public func getBundleResourcesJson(_ json: Data) -> [Any] {
		
		guard let jsContext = createContext() else {
			logError("Could not create JS Context")
			return []
		}
		
		prepareParser(context: jsContext)
		
		do {
			let bundleString = String(decoding: json, as: UTF8.self)
			let parseBundleFunction = jsContext.objectForKeyedSubscript("getBundleResourcesJson")
			guard let resourcesJSValue = parseBundleFunction?.call(withArguments: [bundleString]) else {
				logError("Failed to parse bundle resources")
			  return []
			}
//			logDebug("\(resourcesJSValue)")
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
	public func parseResourceJson(_ json: Data) -> Any? {
		
		guard let jsContext = createContext() else {
			logError("Could not create JS Context")
			return []
		}
		prepareParser(context: jsContext)
		
		let resourceString = String(decoding: json, as: UTF8.self)
		let parseResourceFunction = jsContext.objectForKeyedSubscript("parseResourceJson")
		guard let resourcesJSValue = parseResourceFunction?.call(withArguments: [resourceString]) else {
			logError("Failed to parse resource json")
			return nil
		}
//		logDebug("\(resourcesJSValue)")
		let data = Data(resourcesJSValue.toString().utf8)
		return data
	}
	
	// getUiSchemaJson, i.e. transform a Zib object into a UISchema
	public func getUiSchemaJson(_ json: Data) -> UISchema? {
		
		guard let jsContext = createContext() else {
			logError("Could not create JS Context")
			return nil
		}
		prepareParser(context: jsContext)
		
		do {
			let resourceString = String(decoding: json, as: UTF8.self)
			
			let getUISchemaFunction = jsContext.objectForKeyedSubscript("getUiSchemaJson")
			guard let resourcesJSValue = getUISchemaFunction?.call(withArguments: [resourceString]) else {
				logError("Failed to get UISchema")
				return nil
			}
//			logDebug("\(resourcesJSValue)")
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
