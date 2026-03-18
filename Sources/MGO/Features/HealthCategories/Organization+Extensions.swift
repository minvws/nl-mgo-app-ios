/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OrganizationSearch

/// Convenience extensions on `OrganizationSearch.Organization` for use within the Health Categories feature.
extension OrganizationSearch.Organization {

	/// Returns the resource endpoint URL string for the data service matching the given identifier.
	///
	/// - Parameter identifier: The unique identifier of the data service to look up.
	/// - Returns: The resource endpoint string if a matching data service is found, otherwise `nil`.
	func getResourceEndpoint(identifier: String) -> String? {
		dataServices?.first(where: { $0.id == identifier })?.resourceEndpoint
	}

	/// A convenience alias for the organization's `id` property.
	var identifier: String { id }
}
