/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

final class UpdateRequiredUITests: BaseUITest {
	
	override func setUpWithError() throws {
		app.launchArguments.append("-updateRequired")
		try super.setUpWithError()
	}
	
	func test_updateRequired() {
		
		app.textExists("update_required.heading")
		app.buttons["update_required.download"].tap()
	}
}
