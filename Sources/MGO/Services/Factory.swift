/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOFoundation

extension Container {
	
	var healthcareOrganizationRepository: Factory<HealthcareOrganizationRepositoryProtocol> {
		Factory(self) { HealthcareOrganizationRepository() }
			.singleton
	}
}
