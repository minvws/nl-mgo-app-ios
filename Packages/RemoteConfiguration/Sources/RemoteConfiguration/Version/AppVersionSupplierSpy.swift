/*
*  Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

public class AppVersionSupplierSpy: AppVersionSupplierProtocol {
	
	public init() { /* Public initializer needed for public access */ }

	public var invokedGetCurrentVersion = false
	public var invokedGetCurrentVersionCount = 0
	public var stubbedGetCurrentVersionResult: String! = ""

	public func getCurrentVersion() -> String {
		invokedGetCurrentVersion = true
		invokedGetCurrentVersionCount += 1
		return stubbedGetCurrentVersionResult
	}

	public var invokedGetCurrentBuild = false
	public var invokedGetCurrentBuildCount = 0
	public var stubbedGetCurrentBuildResult: String! = ""

	public func getCurrentBuild() -> String {
		invokedGetCurrentBuild = true
		invokedGetCurrentBuildCount += 1
		return stubbedGetCurrentBuildResult
	}
}
