/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

enum HealthCategories {
	
	static var medication = CategoryButton(id: 1, title: "health_category.medication", state: .loading)
	
	static var allergies = CategoryButton(id: 2, title: "health_category.allergies", state: .notAvailabe)
	
	static var measurements = CategoryButton(id: 3, title: "health_category.measurements", state: .notAvailabe)
	
	static var vaccinations = CategoryButton(id: 4, title: "health_category.vaccinations", state: .notAvailabe)
	
	static var complaints = CategoryButton(id: 5, title: "health_category.complaints", state: .notAvailabe)

	static var treatments = CategoryButton(id: 6, title: "health_category.treatments", state: .notAvailabe)

	static var labresults = CategoryButton(id: 7, title: "health_category.labresults", state: .notAvailabe)

	static var reports = CategoryButton(id: 8, title: "health_category.reports", state: .notAvailabe)
	
	static var documents = CategoryButton(id: 9, title: "health_category.documents", state: .notAvailabe)
}
