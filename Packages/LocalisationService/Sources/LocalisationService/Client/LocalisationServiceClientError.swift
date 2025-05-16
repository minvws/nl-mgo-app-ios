/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Errors for the Localisation Service Client
public enum LocalisationServiceClientError: Error {
	case noServer
	case noOrganizations
}
