/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Errors thrown by `JSContextManager` during JavaScript context operations.
public enum JSContextManagerError: Error, Sendable {

	/// The input data could not be converted to a valid UTF-8 string, or the
	/// JSON object could not be serialised for JavaScript consumption.
	case invalidInput

	/// The requested method does not exist in the JavaScript parser namespace.
	case invalidMethod

	/// The expected namespace (`OrgSearchApi`) was not found in the JS context.
	case invalidNameSpace

	/// A `JSContext` could not be created or is unexpectedly `nil`.
	case noJSContext

	/// The JavaScript method returned no result, or a Promise was rejected.
	case noResult

	/// The bundled JavaScript parser file could not be found or loaded.
	case parserNotFound
}
