/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing

struct OrganizationDatasetTests {

	// MARK: - resourceName

	@Test("resourceName for .remote returns organizations-remote")
	func resourceName_remote() {
		#expect(OrganizationDataset.remote.resourceName == "organizations-remote")
	}

	@Test("resourceName for .test returns organizations-test")
	func resourceName_test() {
		#expect(OrganizationDataset.test.resourceName == "organizations-test")
	}

	@Test("resourceName for .benchmark returns organizations-benchmark")
	func resourceName_benchmark() {
		#expect(OrganizationDataset.benchmark.resourceName == "organizations-benchmark")
	}

	// MARK: - endpointsResourceName

	@Test("endpointsResourceName for .remote returns endpoints-remote")
	func endpointsResourceName_remote() {
		#expect(OrganizationDataset.remote.endpointsResourceName == "endpoints-remote")
	}

	@Test("endpointsResourceName for .test returns endpoints-test")
	func endpointsResourceName_test() {
		#expect(OrganizationDataset.test.endpointsResourceName == "endpoints-test")
	}

	@Test("endpointsResourceName for .benchmark returns endpoints-benchmark")
	func endpointsResourceName_benchmark() {
		#expect(OrganizationDataset.benchmark.endpointsResourceName == "endpoints-benchmark")
	}

	// MARK: - requiresAPIDownload

	@Test("requiresAPIDownload is true only for .remote")
	func requiresAPIDownload_onlyTrueForRemote() {
		#expect(OrganizationDataset.remote.requiresAPIDownload == true)
		#expect(OrganizationDataset.test.requiresAPIDownload == false)
		#expect(OrganizationDataset.benchmark.requiresAPIDownload == false)
	}
}
