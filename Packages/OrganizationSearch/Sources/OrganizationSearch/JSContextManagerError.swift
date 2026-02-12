/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// the Javascript Context errors
public enum JSContextManagerError: Error, Sendable {
	
	/// The input could not be converted
	case invalidInput
	
	/// This method is not available in the JS parser
	case invalidMethod
	
	/// This namespace is not available in the JS parser
	case invalidNameSpace
	
	/// Failed to initiate a JS Context
	case noJSContext

	/// The providers where not indexed
	case noIndex
	
	/// There was no output
	case noResult
	
	/// The parser was not found at its location
	case parserNotFound
}
