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
			.navigateToOverviewWithBGZ()
			.tapHealthCategory("Medicijnen")
			.tapSectionRow(0, section: 0)
			.verifyHeadingExists("Zestril tablet 10mg")
			.verifySectionRowExists("Gebruiksaanwijzing", value: "1 maal per dag 1 tablet, oraal")
			.verifySectionRowExists("Hoeveelheid per keer", value: "1 stuk")
			.verifySectionRowExists("Status", value: "in gebruik")
			.verifySectionRowExists("Reden gebruik", value: "Niet bekend")
			.verifySectionHeaderExists("Periode van gebruik")
			.verifySectionRowExists("Ingangsdatum", value: "28 juni 2018")
			.verifySectionRowExists("Einddatum", value: "Niet bekend")
			.verifySectionHeaderExists("Voorgeschreven door")
			.verifySectionRowExists("Specialist", value: "Huisartspraktijk Heideroosje")
			.verifyDetailButton("Bekijk alle medicijngegevens")
	}
	
	@MainActor
	func testMedicationDetails() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.tapHealthCategory("Medicijnen")
			.tapSectionRow(0, section: 0)
			.tapNavigatoToDetailsButton("Bekijk alle medicijngegevens")
			.verifyHeadingExists("Zestril tablet 10mg")
			.verifySectionHeaderExists("Algemeen")
			.verifyReferenceButtonExists("Gebruiksproduct", value: "Zestril tablet 10mg")
			.verifySectionRowExists("Registratiedatum", value: "16 augustus 2018")
			.verifySectionRowExists("Ingangsdatum", value: "28 juni 2018")
			.verifySectionRowExists("Einddatum", value: "Niet bekend")
			.verifySectionRowExists("Tijdsduur", value: "3 weken")
			.verifySectionRowExists("Voorschrijver", value: "Huisartspraktijk Heideroosje")
			.verifySectionRowExists("Reden gebruik", value: "Niet bekend")
			.verifySectionRowExists("Volgens afspraak indicator", value: "Ja")
			.verifySectionRowExists("Gebruik indicator", value: "y")
			.verifySectionRowExists("Medicatie gebruik stop type", value: "in gebruik")
			.verifySectionRowExists("Reden wijzigen of stoppen gebruik", value: "Niet bekend")
			.verifySectionRowExists("Herhaalperiode cyclisch schema", value: "Niet bekend")
			.verifySectionRowExists("Medicamenteuze behandeling", value: "Niet bekend")
			.verifySectionRowExists("Toelichting", value: "Niet bekend")
			.verifySectionHeaderExists("Gebruiksinstructie")
			.verifySectionRowExists("Omschrijving", value: "1 maal per dag 1 tablet, oraal")
			.verifySectionRowExists("Toedieningsweg", value: "Oraal (9 in code systeem urn:oid:2.16.840.1.113883.2.4.4.9)")
			.verifySectionRowExists("Aanvullende instructie", value: "Niet bekend")
			.verifySectionRowExists("Volgnummer", value: "1")
			.verifySectionRowExists("Keerdosis", value: "1 stuk")
			.verifySectionRowExists("Teller", value: "Niet bekend")
			.verifySectionRowExists("Noemer", value: "Niet bekend")
			.verifySectionRowExists("Zo nodig", value: "Niet bekend")
			.verifySectionHeaderExists("Toedieningsschema")
			.verifySectionRowExists("Toedieninsgduur", value: "Niet bekend") // should be fixed in upcoming release
			.verifySectionRowExists("Frequentie", value: "1")
			.verifySectionRowExists("Maximum waarde", value: "Niet bekend")
			.verifySectionRowExists("Interval", value: "1 d")
			.verifySectionRowExists("Weekdagen", value: "Niet bekend")
			.verifySectionRowExists("Toedientijd", value: "Niet bekend")
			.verifySectionRowExists("Dagdeel", value: "Niet bekend")
	}
}
