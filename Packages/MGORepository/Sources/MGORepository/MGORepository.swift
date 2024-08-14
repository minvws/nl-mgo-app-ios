/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public class MGORepository {
	
	var client: FHIRClient
	
	public init(client: FHIRClient) {
		self.client = client
	}
	
	public func getBundle(endpoint: DVP.Endpoint, dvaTarget: String) async throws -> ModelsSTU3.Bundle? {
		
		var path = endpoint.path
		if let directory = endpoint.directory {
			path += "/\(directory)"
		}
		
		var parameters = RequestParameters()
		if let params = endpoint.parameters {
			parameters = params
		}
		
		let resource = try await ModelsSTU3.Resource.readFrom(
			path,
			client: client,
			parameters: parameters,
			options: [],
			headers: RequestHeaders([RequestHeaderField.dvaTarget: dvaTarget])
		)
		
		return resource as? ModelsSTU3.Bundle
	}
}
