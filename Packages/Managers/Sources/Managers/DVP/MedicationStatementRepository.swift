/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public protocol MedicationStatementRepository {
	
	/// List all the medication statements
	/// - Returns: an array of medication statements
	func list() async throws -> [MedicationStatement]
}

extension FHIRClient: MedicationStatementRepository {
	
	/// List all the medication statements
	/// - Returns: an array of medication statements
	public func list() async throws -> [ModelsSTU3.MedicationStatement] {
		
		let bundle = try await MedicationStatement.read("", client: self, parameters: DVPClient.BGZ.MedicationStatement) as? ModelsSTU3.Bundle
		let statements: [MedicationStatement]? = bundle?.entry?.compactMap {
			$0.resource?.get(if: ModelsSTU3.MedicationStatement.self)
		}
		return statements ?? []
	}
}
