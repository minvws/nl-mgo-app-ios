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
	
	private let jsContext = JSContext()
	
	/// Initializer
	public init() {
		
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
	}
	
	public func parse(_ bundle: ModelsSTU3.Bundle?) -> UISchema? {
		
		guard let bundle else { return nil }
		
		guard let parserPath = Bundle.module.path(forResource: "parser", ofType: "js") else {
			logError("file not found")
			return nil
		}
		
		do {
			let sourceContents = try String(contentsOfFile: parserPath)
			jsContext?.evaluateScript(sourceContents)
			
			let json = try Resource.toJson(bundle)
			let bundleString = String(decoding: json, as: UTF8.self)
			
			let functionString = "parseBundle(\(bundleString))"
			let result = jsContext?.evaluateScript(functionString)
			if let object = result?.toString() {
				let schema = try UISchema(object)
				return schema
			}
			
		} catch {
			logError(error.localizedDescription)
		}
		
		return nil
	}
}
