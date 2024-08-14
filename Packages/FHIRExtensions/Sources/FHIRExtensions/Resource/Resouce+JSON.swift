/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Resource {
	
	public static func fromJSON<T>(_ json: Data, type: T.Type) throws -> T where T: Decodable {
		
		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: json)
	}
	
	public static func toJson<T>(_ type: T) throws -> Data where T: Encodable {
		let encoder = JSONEncoder()
		return try encoder.encode(type)
	}
}
