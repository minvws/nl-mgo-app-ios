/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class AppRobot: Robot {
	
	@discardableResult
	func launchApp() -> IntroductionRobot {
		app.launchArguments.append("-resetOnStart")
		app.launchArguments.append("-disableTransitions")
		app.launch()
		return IntroductionRobot()
	}
	
//	///Launches the app and handles the standard process to add a new scrum meeting, validating the scrum details appear as expected in the scrum list
//	@discardableResult
//	func launchAppWithNewScrum(scrumName: String = "Design Meeting",
//							   attendees: [String] = ["John", "Alice", "Bob"],
//							   meetingLengthValue: CGFloat = 1.0,
//							   meetingMinutes: Int = 30) -> ScrumListRobot {
//		self.launchApp()
//			.tapAddScrumButton()
//			.inputScrumTitle(scrumName)
//			.setDurationSlider(meetingLengthValue)
//			.tapThemeSelectionButton()
//			.tapThemeOrangeButton()
//			.addAttendees(attendees)
//			.tapCreateScrumButton()
//			.verifyScrumTitleExists(named: scrumName)
//			.verifyAttendeeCountExists(count: attendees.count)
//			.verifyMeetingLengthExists(minutes: meetingMinutes)
//	}
	
	func terminateApp() {
		app.terminate()
	}
}
