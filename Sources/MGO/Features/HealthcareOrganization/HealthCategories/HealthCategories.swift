/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct HealthCategories {
	
	enum Category: Int, CaseIterable {
		case medication = 1
		case allergies = 2
		case measurements = 3
		case vaccinations = 4
		case complaints = 5
		case treatments = 6
		case labresults = 7
		case reports = 8
		case documents = 9
	}
}
