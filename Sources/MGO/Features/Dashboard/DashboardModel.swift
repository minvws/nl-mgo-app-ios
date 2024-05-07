/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

struct DashboardModel: Codable, Hashable, Equatable, Identifiable {
	
	/// The category of healthcare provider (dentist, gp, etc)
	var category: String
	
	/// The identifier
	var id: String
	
	/// The name of the healthcare provider
	var name: String
}

class DashboardDecorator {
	
	/// Create a DashboardModel from a HealthcareProvider
	/// - Parameter from: HealthcareProvider
	/// - Returns: DashboardModel
	static func create(_ organisation: HealthcareProvider) -> DashboardModel {
		
		let identifier = organisation.identification_type + "|" + organisation.identification_value
		let name = organisation.display_name // + " [\(identifier)]"

		return DashboardModel(category: organisation.types.first?.display_name ?? "", id: identifier, name: name)
	}
}
