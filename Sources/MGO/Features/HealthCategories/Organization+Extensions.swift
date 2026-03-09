/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OrganizationSearch

extension OrganizationSearch.Organization {

	var category: String? { careTypeDisplay }

	func getResourceEndpoint(identifier: String) -> String? {
		dataServices?[identifier]?.resourceEndpoint
	}

	var identifier: String { id }
}
