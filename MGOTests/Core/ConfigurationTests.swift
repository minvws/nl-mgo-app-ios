/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
@testable import MGO

struct ConfigurationTests {

	// MARK: - urlForLocalization -

	@Test("urlForLocalization returns test URL for .test release")
	func urlForLocalization_test() {

		// Given
		let release = Release.test

		// When
		let url = Configuration().urlForLocalization(for: release)

		// Then
		#expect(url.absoluteString == "https://lo-ad.test.mgo.irealisatie.nl")
	}

	@Test("urlForLocalization returns test URL for .development release")
	func urlForLocalization_development() {

		// Given
		let release = Release.development

		// When
		let url = Configuration().urlForLocalization(for: release)

		// Then
		#expect(url.absoluteString == "https://lo-ad.test.mgo.irealisatie.nl")
	}

	@Test("urlForLocalization returns acceptance URL for .acceptance release")
	func urlForLocalization_acceptance() {

		// Given
		let release = Release.acceptance

		// When
		let url = Configuration().urlForLocalization(for: release)

		// Then
		#expect(url.absoluteString == "https://lo-ad.acc.mgo.irealisatie.nl")
	}

	@Test("urlForLocalization returns acceptance URL for .production release")
	func urlForLocalization_production() {

		// Given
		let release = Release.production

		// When
		let url = Configuration().urlForLocalization(for: release)

		// Then
		#expect(url.absoluteString == "https://lo-ad.acc.mgo.irealisatie.nl")
	}

	// MARK: - urlForRemoteConfiguration -

	@Test("urlForRemoteConfiguration returns test URL for .test release")
	func urlForRemoteConfiguration_test() {

		// Given
		let release = Release.test

		// When
		let url = Configuration().urlForRemoteConfiguration(for: release)

		// Then
		#expect(url.absoluteString == "https://app-api.test.mgo.irealisatie.nl/v1/mgo")
	}

	@Test("urlForRemoteConfiguration returns test URL for .development release")
	func urlForRemoteConfiguration_development() {

		// Given
		let release = Release.development

		// When
		let url = Configuration().urlForRemoteConfiguration(for: release)

		// Then
		#expect(url.absoluteString == "https://app-api.test.mgo.irealisatie.nl/v1/mgo")
	}

	@Test("urlForRemoteConfiguration returns acceptance URL for .acceptance release")
	func urlForRemoteConfiguration_acceptance() {

		// Given
		let release = Release.acceptance

		// When
		let url = Configuration().urlForRemoteConfiguration(for: release)

		// Then
		#expect(url.absoluteString == "https://app-api.acc.mgo.irealisatie.nl/v1/mgo")
	}

	@Test("urlForRemoteConfiguration returns acceptance URL for .production release")
	func urlForRemoteConfiguration_production() {

		// Given
		let release = Release.production

		// When
		let url = Configuration().urlForRemoteConfiguration(for: release)

		// Then
		#expect(url.absoluteString == "https://app-api.acc.mgo.irealisatie.nl/v1/mgo")
	}

	// MARK: - urlForDVP -

	@Test("urlForDVP returns test URL for .test release")
	func urlForDVP_test() {

		// Given
		let release = Release.test

		// When
		let url = Configuration().urlForDVP(for: release)

		// Then
		#expect(url.absoluteString == "https://dvp-proxy.test.mgo.irealisatie.nl/fhir")
	}

	@Test("urlForDVP returns test URL for .development release")
	func urlForDVP_development() {

		// Given
		let release = Release.development

		// When
		let url = Configuration().urlForDVP(for: release)

		// Then
		#expect(url.absoluteString == "https://dvp-proxy.test.mgo.irealisatie.nl/fhir")
	}

	@Test("urlForDVP returns acceptance URL for .acceptance release")
	func urlForDVP_acceptance() {

		// Given
		let release = Release.acceptance

		// When
		let url = Configuration().urlForDVP(for: release)

		// Then
		#expect(url.absoluteString == "https://dvp-proxy.acc.mgo.irealisatie.nl/fhir")
	}

	@Test("urlForDVP returns acceptance URL for .production release")
	func urlForDVP_production() {

		// Given
		let release = Release.production

		// When
		let url = Configuration().urlForDVP(for: release)

		// Then
		#expect(url.absoluteString == "https://dvp-proxy.acc.mgo.irealisatie.nl/fhir")
	}

	// MARK: - urlForOIDC -

	@Test("urlForOIDC returns test URL for .test release")
	func urlForOIDC_test() {

		// Given
		let release = Release.test

		// When
		let url = Configuration().urlForOIDC(for: release)

		// Then
		#expect(url.absoluteString == "https://dvp-proxy.test.mgo.irealisatie.nl")
	}

	@Test("urlForOIDC returns test URL for .development release")
	func urlForOIDC_development() {

		// Given
		let release = Release.development

		// When
		let url = Configuration().urlForOIDC(for: release)

		// Then
		#expect(url.absoluteString == "https://dvp-proxy.test.mgo.irealisatie.nl")
	}

	@Test("urlForOIDC returns acceptance URL for .acceptance release")
	func urlForOIDC_acceptance() {

		// Given
		let release = Release.acceptance

		// When
		let url = Configuration().urlForOIDC(for: release)

		// Then
		#expect(url.absoluteString == "https://dvp-proxy.acc.mgo.irealisatie.nl")
	}

	@Test("urlForOIDC returns acceptance URL for .production release")
	func urlForOIDC_production() {

		// Given
		let release = Release.production

		// When
		let url = Configuration().urlForOIDC(for: release)

		// Then
		#expect(url.absoluteString == "https://dvp-proxy.acc.mgo.irealisatie.nl")
	}
}
