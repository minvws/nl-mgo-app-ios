/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRExtensions

/// Decorator
public class MedicationUseDecorator {
	
	/// Create a Mgo Medication Use from a STU3 Medication Statement
	/// - Parameter statement: STU3 Medication Statement
	/// - Returns: Mgo Medication Use
	public static func create(_ statement: MedicationStatement) -> MgoMedicationUse? {
		
		return MgoMedicationUse(
			title: statement.medicationName ?? "",
			instructions: statement.dosageText,
			prescribedBy: statement.prescriber,
			startDate: statement.startDate,
			status: statement.status.value?.rawValue
		)
	}
}
