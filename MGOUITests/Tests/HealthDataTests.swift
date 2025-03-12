/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class HealthDataTests: XCTestCase {
	
	@MainActor
	func testMedicationSummary() {
		
		AppRobot()
			.startWithBGZ()
			.tapCategory("Medicijnen")
			.tapElement(0, section: 0)
			.verifyHeading("Zestril tablet 10mg")
			.verifySectionRow("Gebruiksaanwijzing", value: "1 maal per dag 1 tablet, oraal")
			.verifySectionRow("Hoeveelheid per keer", value: "1 stuk")
			.verifySectionRow("Status", value: "in gebruik")
			.verifySectionRow("Reden gebruik", value: "Niet bekend")
			.verifySectionHeader("Periode van gebruik")
			.verifySectionRow("Ingangsdatum", value: "28 juni 2018")
			.verifySectionRow("Einddatum", value: "Niet bekend")
			.verifySectionHeader("Voorgeschreven door")
			.verifySectionRow("Specialist", value: "Huisartspraktijk Heideroosje")
			.verifyDetailButton("Bekijk alle medicijngegevens")
	}
	
	@MainActor
	func testMedicationDetails() {
		
		AppRobot()
			.startWithBGZ()
			.tapCategory("Medicijnen")
			.tapElement(0, section: 0)
			.tapDetailButton("Bekijk alle medicijngegevens")
			.verifyHeading("Zestril tablet 10mg")
			.verifySectionHeader("Algemeen")
			.verifyReferenceButton("Gebruiksproduct", value: "Zestril tablet 10mg")
			.verifySectionRow("Registratiedatum", value: "16 augustus 2018")
			.verifySectionRow("Ingangsdatum", value: "28 juni 2018")
			.verifySectionRow("Einddatum", value: "Niet bekend")
			.verifySectionRow("Tijdsduur", value: "3 weken")
			.verifySectionRow("Voorschrijver", value: "Huisartspraktijk Heideroosje")
			.verifySectionRow("Reden gebruik", value: "Niet bekend")
			.verifySectionRow("Volgens afspraak indicator", value: "Ja")
			.verifySectionRow("Gebruik indicator", value: "y")
			.verifySectionRow("Medicatie gebruik stop type", value: "in gebruik")
			.verifySectionRow("Reden wijzigen of stoppen gebruik", value: "Niet bekend")
			.verifySectionRow("Herhaalperiode cyclisch schema", value: "Niet bekend")
			.verifySectionRow("Medicamenteuze behandeling", value: "Niet bekend")
			.verifySectionRow("Toelichting", value: "Niet bekend")
			.verifySectionHeader("Gebruiksinstructie")
			.verifySectionRow("Omschrijving", value: "1 maal per dag 1 tablet, oraal")
			.verifySectionRow("Toedieningsweg", value: "Oraal (9 in code systeem urn:oid:2.16.840.1.113883.2.4.4.9)")
			.verifySectionRow("Aanvullende instructie", value: "Niet bekend")
			.verifySectionRow("Volgnummer", value: "1")
			.verifySectionRow("Keerdosis", value: "1 stuk")
			.verifySectionRow("Teller", value: "Niet bekend")
			.verifySectionRow("Noemer", value: "Niet bekend")
			.verifySectionRow("Zo nodig", value: "Niet bekend")
			.verifySectionHeader("Toedieningsschema")
			.verifySectionRow("Toedieninsgduur", value: "Niet bekend") // should be fixed in upcoming release
			.verifySectionRow("Frequentie", value: "1")
			.verifySectionRow("Maximum waarde", value: "Niet bekend")
			.verifySectionRow("Interval", value: "1 d")
			.verifySectionRow("Weekdagen", value: "Niet bekend")
			.verifySectionRow("Toedientijd", value: "Niet bekend")
			.verifySectionRow("Dagdeel", value: "Niet bekend")
	}
}
