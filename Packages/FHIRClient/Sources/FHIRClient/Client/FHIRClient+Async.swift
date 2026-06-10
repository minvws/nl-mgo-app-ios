/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import HTTPTypes

extension FHIRClient {

	/**
	 Reads the resource from the given path on the given server as Data.

	 - parameter path:       The relative path on the server to read resource data from
	 - parameter parameters: The request parameters to add as URL query items
	 - parameter headers:    Headers to send to the server
	 - Returns: the requested data
	 */
	public func readDataFrom(
		_ path: String,
		parameters: RequestParameters = RequestParameters(),
		headers: HTTPFields = HTTPFields()
	) async throws -> Data {

		let handler = self.handlerForRequest(withMethod: .get)
		handler.parameters = parameters
		handler.add(headers: headers)

		let response = await self.performRequest(against: path, handler: handler)

		if let error = response.error {
			throw error
		} else {
			guard response.status == 200, let body = response.body else {
				throw FHIRError.responseNoResourceReceived
			}
			return body
		}
	}
}
