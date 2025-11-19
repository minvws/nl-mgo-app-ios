/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor
final class HealthDataFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the health data flow
	 ✅ Verify the medication flow for a BGZ healthcare organization
	 ✅ Verify the laboratory result flow for a GP healthcare organization
	 ✅ Verify the document flow for a PDFA healthcare organization
	 ✅ Verify the vaccination flow for a Vaccination healthcare organization
	 */
	
	@MainActor
	func testHealthDataFlow_BGZ() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
			.verifyAllCategories()
		
			.verifyOverviewButtonExists()
			.verifyHealthcareOrganizationButtonExists()
			.verifySettingsButtonExists()

			// Medication Category
			.swipeUpToCategory("medication")
			.tapHealthCategory("medication")
			.verifyHeadingExists("Medicijnen")
			.verifySectionExists("Wat je nu gebruikt")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionRowExists("Zestril tablet 10mg, Kwalificatie Medmij: BGZ")
			.verifySectionExists("Afspraken over je medicijnen")
			.verifySectionButtonExists(0, section: 1)
			.verifySectionRowExists("a257c163-5250-4589-9e0d-dfecf807ce0c, Kwalificatie Medmij: BGZ")
			.verifySectionExists("Hoe je je medicijnen krijgt")
			.verifySectionButtonExists(0, section: 2)
			.verifySectionRowExists("94611f8e-588c-406e-b9d7-ede20a2d996a, Kwalificatie Medmij: BGZ")
			.tapSectionRow(0, section: 0)
			// Medication Summary
			.verifyHeadingExists("Zestril tablet 10mg")
			.verifySectionRowExists("Gebruiksaanwijzing", value: "1 maal per dag 1 tablet, oraal")
			.verifySectionRowExists("Hoeveelheid per keer", value: "1 stuk")
			.verifySectionRowExists("Status", value: "Actief")
			.verifySectionRowExists("Reden gebruik", value: "verpleegkundige verrichting (verrichting)")
			.verifySectionHeaderExists("gegeneraliseerde psoriasis pustulosa (aandoening)")
			.verifySectionHeaderExists("Periode van gebruik")
			.verifySectionRowExists("Ingangsdatum", value: "28 juni 2018")
			.verifySectionRowExists("Einddatum", value: "Niet bekend")
			.verifySectionHeaderExists("Voorgeschreven door")
			.verifySectionRowExists("Specialist", value: "Huisartsen, niet nader gespecificeerd")
			.verifySectionRowExists("Zorgaanbieder", value: "Kwalificatie Medmij: BGZ")
			.verifySectionHeaderExists("Opties")
			.verifyDetailButton("Bekijk alle medicijngegevens")
			// Medication Details
			.tapNavigateToDetailsButton("Bekijk alle medicijngegevens")
			.verifyHeadingExists("Medicatiegebruik")
			.verifySectionRowExists("Auteur", value: "Niet bekend")
			.verifySectionRowExists("Gebruik indicator", value: "y")
			.verifyReferenceButtonExists("Gebruiksproduct", value: "Zestril tablet 10mg")
			.verifySectionRowExists("Herhaalperiode cyclisch schema", value: "Niet bekend")
			.verifySectionRowExists("Identificatie", value: "123457000000")
			.verifyReferenceButtonExists("Informatiebron", value: "Johan XXX_Helleman")
			.verifySectionRowExists("Medicamenteuze behandeling", value: "Niet bekend")
			.verifySectionRowExists("Medicatie gebruik stop type", value: "active")
			.verifyReferenceButtonExists("Onderwerp", value: "Johan XXX_Helleman")
			.verifySectionRowExists("Reden gebruik", value: "verpleegkundige verrichting (verrichting) (9632001 in codesysteem http://snomed.info/sct)")
			.verifySectionRowExists("Reden wijzigen of stoppen gebruik", value: "Niet bekend")
			.verifySectionRowExists("Registratiedatum", value: "16 augustus 2018")
			.verifySectionRowExists("Toelichting", value: "Niet bekend")
			.verifySectionRowExists("Volgens afspraak indicator", value: "Ja")
			.verifySectionRowExists("Voorschrijver", value: "Huisartsen, niet nader gespecificeerd")
			.verifySectionHeaderExists("Gebruiksperiode")
			.verifySectionRowExists("Einddatum", value: "Niet bekend")
			.verifySectionRowExists("Ingangsdatum", value: "28 juni 2018")
			.verifySectionRowExists("Tijdsduur", value: "3 week")
			.verifySectionHeaderExists("Gebruiksinstructie")
			.verifySectionRowExists("Aanvullende instructie", value: "Niet bekend")
			.verifySectionRowExists("Dagdeel", value: "Niet bekend")
			.verifySectionRowExists("Frequentie", value: "1")
			.verifySectionRowExists("Interval", value: "1")
			.verifySectionRowExists("Interval", value: "d")
			.verifySectionRowExists("Keerdosis", value: "1 stuk")
			.verifySectionRowExists("Maximale dosering", value: "Niet bekend")
			.verifySectionRowExists("Maximum waarde", value: "Niet bekend")
			.verifySectionRowExists("Omschrijving", value: "1 maal per dag 1 tablet, oraal")
			.verifySectionRowExists("Toedieningsweg", value: "9")
			.verifySectionRowExists("Toedieninsgduur", value: "Niet bekend")
			.verifySectionRowExists("Toedientijd", value: "Niet bekend")
			.verifySectionRowExists("Volgnummer", value: "1")
			.verifySectionRowExists("Weekdagen", value: "Niet bekend")
			.verifySectionRowExists("Zo nodig", value: "Niet bekend")
	}
	
	@MainActor
	func testHealthDataFlow_GP() {
		
		AppRobot()
			.navigateToOverviewWithGP()
			.verifyTitleExists("Overzicht")
			.verifyAllCategories()
			.verifyOverviewButtonExists()
			.verifyHealthcareOrganizationButtonExists()
			.verifySettingsButtonExists()
			// Laboratory Results Category
			.swipeUpToCategory("lab_results")
			.tapHealthCategory("lab_results")
			.verifyHeadingExists("Uitslagen")
			.verifySectionRowExists("Consult voor hnp (thoracaal/lumbaal) met dokter bernard, Kwalificatie Medmij: GPDATA")
			.verifySectionRowExists("Consult voor keelpijn met dokter bernard, Kwalificatie Medmij: GPDATA")
			.tapSectionRow(0, section: 1)
			// Laboratory Result Summary
			.verifyHeadingExists("Consult voor hnp (thoracaal/lumbaal) met dokter bernard")
			.verifySectionRowExists("Datum van de uitslag", value: "18 maart 2024")
			.verifySectionRowExists("Resultaat", value: "5,4 millimol per liter")
			.verifySectionRowExists("Interpretatie", value: "Niet bekend")
			.verifySectionHeaderExists("Details van de test")
			.verifySectionRowExists("Status", value: "Definitief")
			.verifySectionRowExists("Materiaal", value: "Niet bekend")
			.verifySectionHeaderExists("Normale referentiewaarden")
			.verifySectionRowExists("Minimale waarde", value: "3,5 millimol per liter")
			.verifySectionRowExists("Maximale waarde", value: "5,6 millimol per liter")
			.verifySectionHeaderExists("Test afgenomen door")
			.verifySectionRowExists("Specialist", value: "Dokter Bernard")
			.verifySectionRowExists("Zorgaanbieder", value: "Kwalificatie Medmij: GPDATA")
			.verifySectionHeaderExists("Opties")
			.verifyDetailButton("Bekijk alle uitslaggegevens")
			// Laboratory Result Details
			.tapNavigateToDetailsButton("Bekijk alle uitslaggegevens")
			.verifyHeadingExists("Laboratorium uitslag")
			.verifySectionRowExists("Aanvrager", value: "Niet bekend")
			.verifySectionRowExists("Auteur", value: "Dokter Bernard")
			.verifyReferenceButtonExists("Contact", value: "Consult voor HNP (thoracaal/lumbaal) met Dokter Bernard")
			.verifySectionRowExists("Gerelateerde uitslag", value: "Niet bekend")
			.verifySectionRowExists("Identificatie", value: "c1975acb-041c-11ec-1725-020000000000")
			.verifySectionRowExists("Interpretatie vlaggen", value: "Niet bekend")
			.verifySectionRowExists("Monster", value: "Niet bekend")
			.verifyReferenceButtonExists("Patiënt", value: "Jacqueline XXX_Cevat")
			.verifySectionRowExists("Test code", value: "3208")
			.verifySectionRowExists("Test datum tijd", value: "18 maart 2024")
			.verifySectionRowExists("Test uitslag", value: "5,4 millimol per liter")
			.verifySectionRowExists("Test uitslag status", value: "final")
			.verifySectionRowExists("Testmethode", value: "Niet bekend")
			.verifySectionRowExists("Toelichting", value: "Niet bekend")
			.verifySectionHeaderExists("Categorie")
			.verifySectionRowExists("Resultaat code", value: "49581000146104")
			.verifySectionRowExists("Resultaat type", value: "Niet bekend")
			.verifySectionHeaderExists("Referentie")
			.verifySectionRowExists("Referentie ondergrens", value: "3,5 millimol per liter")
			.verifySectionRowExists("Referentie bovengrens", value: "5,6 millimol per liter")
			.verifySectionRowExists("Referentie type", value: "normal")
	}
	
	@MainActor
	func testHealthDataFlow_Document() {
		
		AppRobot()
			.navigateToOverviewWithPDFA()
			.verifyTitleExists("Overzicht")
			.verifyAllCategories()
			.verifyOverviewButtonExists()
			.verifyHealthcareOrganizationButtonExists()
			.verifySettingsButtonExists()
			// Document Category
			.swipeUpToCategory("documents")
			.tapHealthCategory("documents")
			.verifyHeadingExists("Documenten")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionRowExists("Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary, Kwalificatie Medmij: PDFA")
			.verifySectionButtonExists(1, section: 0)
			.verifySectionRowExists("Example PDF - Infectious disease Consult note, Kwalificatie Medmij: PDFA")
			.tapSectionRow(0, section: 0)
			// Document Summary
			.verifyHeadingExists("Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary")
			.verifySectionRowExists("Aangemaakt op", value: "13 juli 2022 om 01:00")
			.verifySectionRowExists("Onderwerp", value: "E XXX_Baltus")
			.verifySectionRowExists("Type", value: "Samenvattende ontslagbrief [bevinding] in {instelling} d.m.v. neurochirurgie (document)")
			.swipeDownToSection("Bijlage")
			.verifySectionHeaderExists("Bijlage")
			.verifyAttachmentButton("Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary")
			.swipeDownToSection("Opgesteld door")
			.verifySectionHeaderExists("Opgesteld door")
			.verifySectionRowExists("Specialist", value: "A.F. Snijder")
			.verifySectionRowExists("Zorgaanbieder", value: "Kwalificatie Medmij: PDFA")
			.swipeDownToSection("Opties")
			.verifySectionHeaderExists("Opties")
			.verifyDetailButton("Bekijk alle documentgegevens")
			// Document Details
			.tapNavigateToDetailsButton("Bekijk alle documentgegevens")
			.verifyHeadingExists("Document")
			.verifySectionRowExists("Aangemaakt op", value: "13 juli 2022 om 01:00:00 GMT+2")
			.verifySectionRowExists("Beveiligingslabel", value: "V")
			.verifySectionRowExists("Categorie", value: "18842-5")
		
			.verifySectionRowExists("Gerelateerd aan", value: "Niet bekend")
			.verifySectionRowExists("Identificatie", value: "852852")
			.verifySectionRowExists("Identifier", value: "urn:uuid:0567a09b-0c38-414e-9193-7723c6910b3a")
			.verifySectionRowExists("Onderwerp", value: "E XXX_Baltus")
			.verifySectionRowExists("Specialist", value: "A.F. Snijder")
			.verifySectionRowExists("Status", value: "current")

			.verifySectionRowExists("Type", value: "68688-1")
			.swipeDownToSection("Inhoud")
			.verifySectionHeaderExists("Inhoud")
			.verifyAttachmentButton("Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary")
			.verifySectionRowExists("Formaat", value: "Niet bekend")
			.swipeDownToSection("Klinische context")
			.verifySectionHeaderExists("Klinische context")
			.verifySectionRowExists("Aanvullende details", value: "Niet bekend")
			.verifySectionRowExists("Faciliteit", value: "Niet bekend")
			.verifySectionRowExists("Patiënt informatie", value: "Niet bekend")
			.verifySectionRowExists("Periode", value: "Niet bekend")
			.tapAttachmentButton("Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary")
			.verifyBackButtonExists()
			.tapBackButton()
	}
	
	@MainActor
	func testHealthDataFlow_Vaccination() {
		
		AppRobot()
			.navigateToOverviewWithVaccination()
			.verifyTitleExists("Overzicht")
			.verifyAllCategories()
			.verifyOverviewButtonExists()
			.verifyHealthcareOrganizationButtonExists()
			.verifySettingsButtonExists()
			// Vaccination Category
			.swipeUpToCategory("vaccinations")
			.tapHealthCategory("vaccinations")
			.verifyHeadingExists("Vaccinaties")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionRowExists("Covid-19 vaccin pfizer injvlst 0,3ml, Kwalificatie Medmij: VACCINATION_IMMUNIZATION")
			.tapSectionRow(0, section: 0)
			// Vaccination Summary
			.verifyHeadingExists("Covid-19 vaccin pfizer injvlst 0,3ml")
			.verifySectionRowExists("Vaccinatie datum", value: "19 juni 2021 om 16:17")
			.verifySectionRowExists("Toelichting", value: "Niet bekend")
			.verifySectionHeaderExists("Gegeven door")
			.verifySectionRowExists("Toediener", value: "GGD Gelderland-Zuid")
			.verifySectionRowExists("Zorgaanbieder", value: "Kwalificatie Medmij: VACCINATION_IMMUNIZATION")
			.verifySectionHeaderExists("Opties")
			.verifyDetailButton("Bekijk alle vaccinatiegegevens")
			// Vaccination Details
			.tapNavigateToDetailsButton("Bekijk alle vaccinatiegegevens")
			.verifyHeadingExists("Vaccinatie")
			.verifySectionRowExists("Dosis", value: "Niet bekend")
			.verifySectionRowExists("Identificatienummer", value: "54651")
			.verifySectionRowExists("Inenting", value: "COVID-19 VACCIN PFIZER INJVLST 0,3ML")
			.verifySectionRowExists("Patient", value: "Patient, Johanna Petronella Maria (Jo) van Putten")
			.verifySectionRowExists("Product code", value: "2924528")
			.verifySectionRowExists("Protocol toegepast", value: "Niet bekend")
			.verifySectionRowExists("Status", value: "completed")
			.verifySectionRowExists("Toediener", value: "GGD Gelderland-Zuid")
			.verifySectionRowExists("Toedieningsweg", value: "Niet bekend")
			.verifySectionRowExists("Toelichting", value: "Niet bekend")
			.verifySectionRowExists("Vaccinatie datum", value: "19 juni 2021 om 16:17:00 GMT+2")
			.verifySectionRowExists("Zorgaanbieder", value: "Noordeinde 68")
	}
	
	@MainActor
	func testHealthDataFlow_LongTermCare() {
		
		AppRobot()
			.navigateToOverviewWithLongTermCare()
			.verifyTitleExists("Overzicht")
			.verifyAllCategories()
			.verifyOverviewButtonExists()
			.verifyHealthcareOrganizationButtonExists()
			.verifySettingsButtonExists()
			// Care Team
			.swipeUpToCategory("care_team")
			.tapHealthCategory("care_team")
			.verifyHeadingExists("Behandelaren")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionRowExists("ont-ver-bglz-1-1-nl-core-careteam-01, Kwalificatie Medmij: BGLZ")
			.tapSectionRow(0, section: 0)
			// Care Team Summary
			.verifyHeadingExists("ont-ver-bglz-1-1-nl-core-careteam-01")
			.verifySectionHeaderExists("Opties")
			.verifyDetailButton("Bekijk alle gegevens")
			// Care Team Details
			.tapNavigateToDetailsButton("Bekijk alle gegevens")
			.verifyHeadingExists("Zorgteam")
			.verifySectionRowExists("Identificatie", value: "8fea361b-e3e1-11eb-2548-020000000000")
			.verifyReferenceButtonExists("Onderwerp", value: "Fiona XXX_Mutter")
			.verifySectionRowExists("Periode", value: "Niet bekend")
			.verifyHeadingExists("Deelnemer")
			.verifyReferenceButtonExists("Deelnemer", value: "Laura Lanen")
			.verifySectionRowExists("Zorgverlener rol", value: "Verwijzer (REF in codesysteem http://hl7.org/fhir/v3/ParticipationType)")
			.verifyReferenceButtonExists("Deelnemer", value: "Niels Helmond")
			.verifySectionRowExists("Zorgverlener rol", value: "Hoofdbehandelaar (RESP in codesysteem http://hl7.org/fhir/v3/ParticipationType)")
			.verifyReferenceButtonExists("Deelnemer", value: "Petra Johanna Vreeswijk")
			.verifySectionRowExists("Zorgverlener rol", value: "Niet bekend")
			.verifyReferenceButtonExists("Deelnemer", value: "Thomas Janssen")
			.verifySectionRowExists("Zorgverlener rol", value: "Niet bekend")
			.verifyReferenceButtonExists("Deelnemer", value: "Hilda Bruinsma")
			.verifySectionRowExists("Zorgverlener rol", value: "Niet bekend")
			.verifyReferenceButtonExists("Deelnemer", value: "AA-zkh - Noord")
			.verifySectionRowExists("Zorgverlener rol", value: "Niet bekend")
	}
}
