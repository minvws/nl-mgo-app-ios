/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public typealias MgoResourceRecord = (
	categoryId: String,
	organizationId: String,
	resources: [MgoResource],
	error: Bool
)
