/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public protocol Zib {
	var profile: String { get }
	var id: String? { get }
	var resourceType: String? { get }
}

extension ZibMedicationUse: Zib { }
extension ZibProduct: Zib { }
