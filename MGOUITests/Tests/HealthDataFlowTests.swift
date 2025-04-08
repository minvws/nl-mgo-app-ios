/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

final class HealthDataFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the health data flow
	 - Verify the medication flow for a BGZ healthcare provider
	 - Verify the laboratory result flow for a GP healthcare provider
	 - Verify the document flow for a PDFA healthcare provider
	 - Verify the vaccination flow for a Vaccination healthcare provider
	 */
	
	@MainActor
	func testHealthDataFlow_BGZ() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.verifySubHeadingExists()
			.verifyCategoryExists("Medische klachten")
			.verifyCategoryExists("Uitslagen")
			.verifyCategoryExists("Metingen")
			.verifyCategoryExists("Medicijnen")
			.verifyCategoryExists("Behandelingen")
			.verifyCategoryExists("Afspraken")
			.verifyCategoryExists("Vaccinaties")
			.verifyCategoryExists("Documenten, Geen gegevens")
			.verifyCategoryExists("Allergieën")
			.swipeToBottomCategory()
			.verifyCategoryExists("Mentaal welzijn")
			.verifyCategoryExists("Leefstijl")
			.verifyCategoryExists("Medische hulpmiddelen")
			.verifyCategoryExists("Behandelplan")
			.verifyCategoryExists("Waarschuwingen")
			.verifyCategoryExists("Persoonlijke gegevens")
			.verifyCategoryExists("Betaalgegevens")
			.verifyOverviewButtonExists()
			.verifyHealthcareProviderButtonExists()
			.verifySettingsButtonExists()
			// Medication Category
			.swipeToTopCategory()
			.tapHealthCategory("Medicijnen")
			.verifyHeadingExists("Medicijnen")
			.verifySectionExists("Medicijnen die je gebruikt")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionExists("Afspraken over je medicijnen")
			.verifySectionButtonExists(0, section: 1)
			.verifySectionExists("Hoe je je medicijnen krijgt")
			.verifySectionButtonExists(0, section: 2)
			.tapSectionRow(0, section: 0)
			// Medication Summary
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
			// Medication Details
			.tapNavigateToDetailsButton("Bekijk alle medicijngegevens")
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
	
	@MainActor
	func testHealthDataFlow_GP() {
		
		AppRobot()
			.navigateToOverviewWithGP()
			.verifyTitleExists("Overzicht")
			.verifySubHeadingExists()
			.verifyCategoryExists("Medische klachten, Geen gegevens")
			.verifyCategoryExists("Uitslagen")
			.verifyCategoryExists("Metingen")
			.verifyCategoryExists("Medicijnen")
			.verifyCategoryExists("Behandelingen")
			.verifyCategoryExists("Afspraken")
			.verifyCategoryExists("Vaccinaties, Geen gegevens")
			.verifyCategoryExists("Documenten, Geen gegevens")
			.verifyCategoryExists("Allergieën")
			.swipeToBottomCategory()
			.verifyCategoryExists("Mentaal welzijn, Geen gegevens")
			.verifyCategoryExists("Leefstijl, Geen gegevens")
			.verifyCategoryExists("Medische hulpmiddelen, Geen gegevens")
			.verifyCategoryExists("Behandelplan, Geen gegevens")
			.verifyCategoryExists("Waarschuwingen, Geen gegevens")
			.verifyCategoryExists("Persoonlijke gegevens")
			.verifyCategoryExists("Betaalgegevens, Geen gegevens")
			.verifyOverviewButtonExists()
			.verifyHealthcareProviderButtonExists()
			.verifySettingsButtonExists()
			// Laboratory Results Category
			.swipeToTopCategory()
			.tapHealthCategory("Uitslagen")
			.verifyHeadingExists("Uitslagen")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionButtonExists(1, section: 0)
			.tapSectionRow(0, section: 0)
			// Laboratory Result Summary
			.verifyHeadingExists("Consult voor hnp (thoracaal/lumbaal) met dokter bernard")
			.verifySectionRowExists("Datum van de uitslag", value: "18 maart 2024")
			.verifySectionRowExists("Resultaat", value: "5,4 millimol per liter")
			.verifySectionRowExists("Beoordeling", value: "Niet bekend")
			.verifySectionHeaderExists("Details van de test")
			.verifySectionRowExists("Status", value: "definitief")
			.verifySectionRowExists("Materiaal", value: "Niet bekend")
			.verifySectionHeaderExists("Normale referentiewaarden")
			.verifySectionRowExists("Minimale waarde", value: "3,5 millimol per liter")
			.verifySectionRowExists("Maximale waarde", value: "5,6 millimol per liter")
			.verifySectionHeaderExists("Test afgenomen door")
			.verifySectionRowExists("Specialist", value: "Dokter Bernard")
			.verifySectionRowExists("Zorgaanbieder", value: "Niet bekend")
			.verifyDetailButton("Bekijk alle uitslaggegevens")
			// Laboratory Result Details
			.tapNavigateToDetailsButton("Bekijk alle uitslaggegevens")
			.verifyHeadingExists("Consult voor hnp (thoracaal/lumbaal) met dokter bernard")
			.verifySectionHeaderExists("Laboratorium uitslag")
			.verifySectionRowExists("Identificatie", value: "c1975acb-041c-11ec-1725-020000000000")
			.verifyReferenceButtonExists("Patiënt", value: "Johan XXX_Helleman")
			.verifyReferenceButtonExists("Verband", value: "Consult voor HNP (thoracaal/lumbaal) met Dokter Bernard")
			.verifySectionRowExists("Test datum tijd", value: "18 maart 2024")
			.verifySectionHeaderExists("Algemene testinformatie")
			.verifySectionRowExists("Resultaat type", value: "Niet bekend")
			.verifySectionRowExists("Toelichting", value: "Niet bekend")
			.verifySectionHeaderExists("Laboratoriumtest")
			.verifySectionRowExists("Test code", value: "glucose nuchter, art/cap (lab) (3208 in code systeem https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen)")
			.verifySectionRowExists("Testmethode", value: "Niet bekend")
			.verifySectionRowExists("Test datum tijd", value: "18 maart 2024")
			.verifySectionRowExists("Test uitslag", value: "5,4 millimol per liter")
			.verifySectionRowExists("Test uitslag status", value: "definitief")
			.verifySectionRowExists("Referentie ondergrens", value: "3,5 millimol per liter")
			.verifySectionRowExists("Referentie bovengrens", value: "5,6 millimol per liter")
			.verifySectionRowExists("Referentie type", value: "Normal Range (normal in code systeem http://hl7.org/fhir/referencerange-meaning)")
			.verifySectionRowExists("Interpretatie", value: "Niet bekend")
	}
}
