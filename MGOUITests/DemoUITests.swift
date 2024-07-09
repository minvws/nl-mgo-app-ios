/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

final class DemoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVoegZorgAanbiederToe() throws {
            let app = XCUIApplication()
            
            app.launchArguments.append("-resetOnStart")
            app.launchArguments.append("-disableTransitions")
            app.launch()
        
            // ELEMENTS OF UI
            let volgendeButton = app.buttons["Volgende"]
            let kiescodeTextField = app.staticTexts["Kies een 5-cijferige toegangscode"]
            let bevestigcodeTextField = app.staticTexts["Bevestig je 5-cijferige toegangscode"]
            let nameTextField = app.textFields["add_organization.name"]
            let cityTextField = app.textFields["add_organization.city"]
            let searchButton  = app.buttons["common.search"]
            let digiDButton   = app.buttons["inloggen DigiD"]
            let welkezorgaanbiederTextField = app.staticTexts["Welke zorgaanbieder wil je toevoegen?"]
            let huisartsNooralishahiTextField = app.staticTexts["huisartsenpraktijk Nooralishahi"]
            let huisartsNooralishahiButton = app.buttons["huisartsenparktijk Nooralishahi bekijken?"]
            let klaarButton = app.buttons["Klaar"]
            let zorgaanbiedertoevoegenButton = app.buttons["Zorgaanbieder toevoegen"]
            let overdeappButton = app.buttons["Over de app"]
            let resettheapplicationButton = app.buttons["Reset the application?"]
        
            // UI ACTIONS
            volgendeButton.tap()
            volgendeButton.tap()
            XCTAssert(kiescodeTextField.exists)
            app.buttons["1"].tap()
            app.buttons["1"].tap()
            app.buttons["2"].tap()
            app.buttons["3"].tap()
            app.buttons["4"].tap()
            XCTAssert(bevestigcodeTextField.exists)
//            XCTAssert(app.staticTexts["Log in met je persoonlijke toegangscode"].exists)
            app.buttons["1"].tap()
            app.buttons["1"].tap()
            app.buttons["2"].tap()
            app.buttons["3"].tap()
            app.buttons["4"].tap()
            digiDButton.tap()
            XCTAssert(welkezorgaanbiederTextField.exists)
            nameTextField.tap()
            nameTextField.typeText("Huisarts")
            cityTextField.tap()
            cityTextField.typeText("Amsterdam")
            searchButton.tap()
//            XCTAssert(huisartsNooralishahiTextField.exists)
            huisartsNooralishahiButton.tap()
//            XCTAssert(huisartsNooralishahiTextField.exists)
            klaarButton.tap()
//            XCTAssert(huisartsNooralishahiTextField.exists)
            XCTAssert(zorgaanbiedertoevoegenButton.exists)
            overdeappButton.tap()
            resettheapplicationButton.tap()
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
