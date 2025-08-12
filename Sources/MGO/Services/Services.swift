/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGOFoundation

// MARK: - 1: Define the Services

struct Services {
	var notificationCenter: NotificationCenterProtocol
	var remoteConfigurationRepository: RemoteConfigurationRepositoryProtocol
	var resourceRepository: ResourceRepositoryProtocol
	
	init(
		notificationCenter: NotificationCenterProtocol,
		remoteConfigurationRepository: RemoteConfigurationRepositoryProtocol,
		resourceRepository: ResourceRepositoryProtocol
	) {
		self.notificationCenter = notificationCenter
		self.remoteConfigurationRepository = remoteConfigurationRepository
		self.resourceRepository = resourceRepository
	}
}

// MARK: - 2: Instantiate Private Dependencies

private let notificationCenter = NotificationCenter.default
private let remoteConfigurationRepository = RemoteConfigurationRepository(
	apiClient: RemoteConfigurationClient(serverUrl: Configuration().urlForRemoteConfiguration())
)
private let resourceRepository = ResourceRepository(
	healthcareOrganizationRepository: Container.shared.healthcareOrganizationRepository(),
	dataRepository: Container.shared.dataStore(),
	featureFlagManager: Container.shared.featureFlagManager(),
	serverUrl: Configuration().urlForDVP(),
	username: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
	password: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String
)

// MARK: - 3: Instantiate the Services using private dependencies:

let services: () -> Services = {
	guard !ProcessInfo().isUnitTesting else {
		fatalError("During unit testing, real services should not be instantiated during Services setup.")
	}
	
	return Services(
		notificationCenter: notificationCenter,
		remoteConfigurationRepository: remoteConfigurationRepository,
		resourceRepository: resourceRepository
	)
}

/// A global variable with all the services
var Current: Services! // swiftlint:disable:this identifier_name
