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
	
	public init() { /* empty init for public access */ }
	
	public func parse(_ bundle: ModelsSTU3.Bundle?) -> UISchema? {
	
		guard let bundle else { return nil }
		
		let jsContext = JSContext()
		jsContext?.exceptionHandler = { (ctx: JSContext!, value: JSValue!) in
			// type of String
			let stacktrace = value.objectForKeyedSubscript("stack").toString()
			// type of Number
			let lineNumber = value.objectForKeyedSubscript("line")
			// type of Number
			let column = value.objectForKeyedSubscript("column")
			let moreInfo = "in method \(String(describing: stacktrace)) Line number in file: \(String(describing: lineNumber)), column: \(String(describing: column))"
			logError("JS ERROR: \(String(describing: value)) \(moreInfo)")
		}
		
		guard let parserPath = Bundle.module.path(forResource: "parser", ofType: "js") else {
			logError("file not found")
			return nil
		}
		
		do {
			let sourceContents = try String(contentsOfFile: parserPath)
			jsContext?.evaluateScript(sourceContents)
			
			let json = try Resource.toJson(bundle)
			let jsonString = String(decoding: json, as: UTF8.self)
			
			let testFunction = jsContext?.objectForKeyedSubscript("exposedFunc")
			let result = testFunction?.call(withArguments: [jsonString])
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
