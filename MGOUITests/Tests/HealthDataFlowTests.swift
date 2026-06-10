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
	 ✅ Verify the care-team flow for a BgLZ healthcare organization
	 */
	
	@MainActor
	func testHealthDataFlow_BGZ() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.verifyTitleExists("Overzicht")
		
			.verifyOverviewButtonExists()
			.verifyHealthcareOrganizationButtonExists()
			.verifySettingsButtonExists()

			// Medication Category
			.swipeDownToCategory("medication")
			.tapHealthCategory("medication")
			.verifyHeadingExists("Medicijnen")
			.verifySectionExists("Wat u nu gebruikt")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionRowExists("Zestril tablet 10mg, 28 juni 2018, Kwalificatie Medmij: BGZ")
			.verifySectionExists("Afspraken over uw medicijnen")
			.verifySectionButtonExists(0, section: 1)
			.verifySectionRowExists("a257c163-5250-4589-9e0d-dfecf807ce0c, Kwalificatie Medmij: BGZ")
			.verifySectionExists("Hoe u uw medicijnen krijgt")
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
			.swipeDownToRowHeading("Zorgaanbieder")
			.verifySectionRowExists("Zorgverlener", value: "Huisartsen, niet nader gespecificeerd")
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
			.swipeDownToRowHeading("Reden gebruik")
			.verifySectionRowExists("Reden gebruik", value: "verpleegkundige verrichting (verrichting) (9632001 in codesysteem http://snomed.info/sct)")
			.verifySectionHeaderExists("gegeneraliseerde psoriasis pustulosa (aandoening) (238612002 in codesysteem http://snomed.info/sct)")
			.verifySectionRowExists("Reden wijzigen of stoppen gebruik", value: "Niet bekend")
			.verifySectionRowExists("Registratiedatum", value: "16 augustus 2018")
			.verifySectionRowExists("Toelichting", value: "Niet bekend")
			.verifySectionRowExists("Volgens afspraak indicator", value: "Ja")
			.verifySectionRowExists("Voorschrijver", value: "Huisartsen, niet nader gespecificeerd")
			.swipeDownToRowHeading("Ingangsdatum")
			.verifySectionHeaderExists("Gebruiksperiode")
			.verifySectionRowExists("Einddatum", value: "Niet bekend")
			.verifySectionRowExists("Ingangsdatum", value: "28 juni 2018")
			.verifySectionRowExists("Tijdsduur", value: "3 week")
			.verifySectionHeaderExists("Gebruiksinstructie")
			.verifySectionRowExists("Aanvullende instructie", value: "Niet bekend")
			.verifySectionRowExists("Dagdeel", value: "Niet bekend")
			.verifySectionRowExists("Frequentie", value: "1")
			.swipeDownToRowHeading("Keerdosis")
			.verifySectionRowExists("Interval", value: "1")
			.verifySectionRowExists("Interval", value: "d")
			.verifySectionRowExists("Keerdosis", value: "1 stuk")
			.verifySectionRowExists("Maximale dosering", value: "Niet bekend")
			.verifySectionRowExists("Maximum waarde", value: "Niet bekend")
			.verifySectionRowExists("Omschrijving", value: "1 maal per dag 1 tablet, oraal")
			.verifySectionRowExists("Toedieningsweg", value: "9")
			.verifySectionRowExists("Toedieninsgduur", value: "Niet bekend")
			.swipeDownToRowHeading("Volgnummer")
			.verifySectionRowExists("Toedientijd", value: "Niet bekend")
			.verifySectionRowExists("Volgnummer", value: "1")
			.swipeDownToRowHeading("Weekdagen")
			.verifySectionRowExists("Weekdagen", value: "Niet bekend")
			.verifySectionRowExists("Zo nodig", value: "Niet bekend")
	}
	
	@MainActor
	func testHealthDataFlow_GP() {
		
		AppRobot()
			.navigateToOverviewWithGP()
			.verifyTitleExists("Overzicht")
			// Laboratory Results Category
			.swipeDownToCategory("lab_results")
			.tapHealthCategory("lab_results")
			.verifyHeadingExists("Uitslagen")
			.verifySectionRowExists("Consult voor hnp (thoracaal/lumbaal) met dokter bernard, Kwalificatie Medmij: GPDATA")

			.verifySectionRowExists("Consult voor keelpijn met dokter bernard, Kwalificatie Medmij: GPDATA")
			.tapSectionRow(0, section: 0)
			// Laboratory Result Summary
			.verifyHeadingExists("Consult voor hnp (thoracaal/lumbaal) met dokter bernard")
			.verifySectionRowExists("Datum van de uitslag", value: "18 maart 2024")
			.verifySectionRowExists("Resultaat", value: "5,4 millimol per liter")
			.verifySectionRowExists("Interpretatie", value: "Niet bekend")
			.verifySectionHeaderExists("Details van de test")
			.verifySectionRowExists("Status", value: "Definitief")
			.verifySectionRowExists("Materiaal", value: "Niet bekend")
			.swipeDownToSection("Test afgenomen door")
			.verifySectionHeaderExists("Normale referentiewaarden")
			.verifySectionRowExists("Referentiewaarden", value: "3,5 millimol per liter")
			.verifySectionRowExists("Referentiewaarden", value: "5,6 millimol per liter")
			.verifySectionHeaderExists("Test afgenomen door")
			.verifySectionRowExists("Zorgverlener", value: "Dokter Bernard")
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
			.swipeDownToRowHeading("Test code")
			.verifySectionRowExists("Test code", value: "glucose nuchter, art/cap (lab) (3208 in codesysteem https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen)")
			.verifySectionRowExists("Test datum tijd", value: "18 maart 2024")
			.verifySectionRowExists("Test uitslag", value: "5,4 millimol per liter")
			.verifySectionRowExists("Test uitslag status", value: "final")
			.verifySectionRowExists("Testmethode", value: "Niet bekend")
			.verifySectionRowExists("Toelichting", value: "Niet bekend")
			.verifySectionHeaderExists("Categorie")
			.swipeDownToSection("Referentie")
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
			// Document Category
			.swipeDownToCategory("documents")
			.tapHealthCategory("documents")
			.verifyHeadingExists("Documenten en beelden")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionRowExists("Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary, Kwalificatie Medmij: PDFA")
			.verifySectionButtonExists(0, section: 1)
			.verifySectionRowExists("Example PDF - Infectious disease Consult note, Kwalificatie Medmij: PDFA")
			.tapSectionRow(0, section: 1)
			// Document Summary
			.verifyHeadingExists("Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary")
			.verifySectionRowExists("Aangemaakt op", value: "13 juli 2022 om 01:00")
			.verifySectionRowExists("Type", value: "Samenvattende ontslagbrief [bevinding] in {instelling} d.m.v. neurochirurgie (document)")
			.verifySectionHeaderExists("Bijlage(n)")
			.verifyAttachmentButton("Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary")
			.swipeDownToSection("Opgesteld door")
			.verifySectionHeaderExists("Opgesteld door")
			.verifySectionRowExists("Zorgverlener", value: "A.F. Snijder")
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
			.verifySectionRowExists("Status", value: "current")
			.swipeDownToRowHeading("Zorgverlener")
			.verifySectionRowExists("Type", value: "Samenvattende ontslagbrief [bevinding] in {instelling} d.m.v. neurochirurgie (document) (68688-1 in codesysteem http://loinc.org)")
			.verifySectionRowExists("Zorgverlener", value: "A.F. Snijder")
			.verifySectionHeaderExists("Inhoud")
			.verifyAttachmentButton("Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary")
			.verifySectionRowExists("Formaat", value: "Niet bekend")
			.verifySectionHeaderExists("Klinische context")
			.verifySectionRowExists("Aanvullende details", value: "Niet bekend")
			.swipeDownToRowHeading("Patiënt informatie")
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
			// Vaccination Category
			.swipeDownToCategory("vaccinations")
			.tapHealthCategory("vaccinations")
			.verifyHeadingExists("Vaccinaties")
			.verifySectionButtonExists(0, section: 0)
			.verifySectionRowExists("Covid-19 vaccin astrazeneca injvlst, 18 februari 2022, Kwalificatie Medmij: VACCINATION_IMMUNIZATION")
			.tapSectionRow(0, section: 0)
			// Vaccination Summary
			.verifyHeadingExists("Covid-19 vaccin astrazeneca injvlst")
			.verifySectionRowExists("Datum van de vaccinatie", value: "18 februari 2022")
			.verifySectionHeaderExists("Aandoening door infectie door 'Severe acute respiratory syndrome'-coronavirus 2 (aandoening)")
			.verifySectionRowExists("Extra uitleg", value: "Geen bijzonderheden")
			.verifySectionRowExists("Vaccinatie gekregen?", value: "Voldaan")
			.verifySectionHeaderExists("Gegeven door")
			.verifySectionRowExists("Zorgorganisatie", value: "Healthcare professional (role), Peter (Peer) de Appel, Huisartsen, niet nader gespecificeerd, Huisartsenpraktijk test 06")
			.verifySectionRowExists("Zorgaanbieder", value: "Kwalificatie Medmij: VACCINATION_IMMUNIZATION")
			.swipeDownToSection("Opties")
			.verifySectionHeaderExists("Opties")
			.verifyDetailButton("Bekijk alle vaccinatiegegevens")
			// Vaccination Details
			.tapNavigateToDetailsButton("Bekijk alle vaccinatiegegevens")
			.verifyHeadingExists("Vaccinatie")
			.verifySectionRowExists("Datum van de vaccinatie", value: "18 februari 2022")
//			.verifySectionHeaderExists("Deze vaccinatie is tegen deze ziekte")
			.verifySectionRowExists("Dosis", value: "0.5 ml")
			.verifySectionRowExists("Farmaceutisch product", value: "COVID-19 VACCIN ASTRAZENECA INJVLST")
			.verifySectionRowExists("Identificatienummer", value: "d90e164")
			.verifyReferenceButtonExists("Locatie", value: "Healthcare provider (location), GGD test 06, GGD test 06 West")
			.verifyReferenceButtonExists("Patient", value: "Patient, Antoon van de XXX_Bergge")
			.swipeDownToRowHeading("Toedieningsweg")
			.verifySectionRowExists("Product code", value: "COVID-19 VACCIN ASTRAZENECA INJVLST (2925508 in codesysteem urn:oid:2.16.840.1.113883.2.4.4.7)")
			.verifySectionRowExists("Toedieningsweg", value: "intramusculair (2 in codesysteem urn:oid:2.16.840.1.113883.2.4.4.9)")
			.verifySectionRowExists("Toelichting", value: "Geen bijzonderheden")
			.verifySectionRowExists("Vaccinatie gekregen?", value: "completed")
			.verifySectionHeaderExists("Healthcare professional (role), Peter (Peer) de Appel, Huisartsen, niet nader gespecificeerd, Huisartsenpraktijk test 06")
			.swipeDownToRowHeading("Vaccinatie indicatie")
			.verifySectionRowExists("Vaccinatie aanleiding", value: "Immunisatie nodig vanuit vaccinatieprogramma (situatie) (159741000146107 in codesysteem http://snomed.info/sct)")
//			.verifySectionRowExists("Vaccinatie indicatie", value: "Kwetsbare oudere (bevinding) (404904002 in codesysteem http://snomed.info/sct)")
	}
	
	@MainActor
	func testHealthDataFlow_LongTermCare() {
		
		AppRobot()
			.navigateToOverviewWithLongTermCare()
			.verifyTitleExists("Overzicht")
			// Care Team
			.swipeDownToCategory("care_team")
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
			.swipeDownToReferenceButton("Deelnemer", value: "Petra Johanna Vreeswijk")
			.verifyReferenceButtonExists("Deelnemer", value: "Petra Johanna Vreeswijk")
			.verifySectionRowExists("Zorgverlener rol", value: "Niet bekend")
			.verifyReferenceButtonExists("Deelnemer", value: "Thomas Janssen")
			.verifySectionRowExists("Zorgverlener rol", value: "Niet bekend")
			.verifyReferenceButtonExists("Deelnemer", value: "Hilda Bruinsma")
			.verifySectionRowExists("Zorgverlener rol", value: "Niet bekend")
			.swipeDownToReferenceButton("Deelnemer", value: "AA-zkh - Noord")
			.verifyReferenceButtonExists("Deelnemer", value: "AA-zkh - Noord")
			.verifySectionRowExists("Zorgverlener rol", value: "Niet bekend")
	}
}
