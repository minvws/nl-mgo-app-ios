/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

/// Identifies which bundled organization JSON file to load into the search database.
public enum OrganizationDataset: Sendable {
	
	/// The complete organization dataset (`organizations-full.json`).
	case full
	
	/// A small dataset intended for use in tests (`organizations-test.json`).
	case test
	
	/// A dataset used for benchmark measurements (`organizations-benchmark.json`).
	case benchmark
	
	/// The resource name (without extension) of the JSON file for this dataset.
	var resourceName: String {
		switch self {
			case .full: return "organizations-full"
			case .test: return "organizations-test"
			case .benchmark: return "organizations-benchmark"
		}
	}
}
