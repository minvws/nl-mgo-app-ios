/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOTest
import MGOFoundation
import MGOUI
import PdfExport
@testable import MGO

final class HealthDataMapperTests: XCTestCase {
	
	private var servicesSpies: ServicesSpies!
	var sut: HealthDataMapper!
	
	override func setUp() {

		super.setUp()
		servicesSpies = setupServicesSpies()
		sut = HealthDataMapper()
	}
	
	@MainActor func test_map_withoutSubcategories() {
		
		// Given
		
		// When
		let pdfData = sut.map(.medication, data: [])
		
		// Then
		expect(pdfData) != nil
		expect(pdfData?.heading) == "Medicijnen"
		expect(pdfData?.subHeading) == "Opgeslagen op 14 nov 2023 om 23:13 uur"
		expect(pdfData?.footer) == "Dit document is gemaakt met Mijn Gezondheidsoverzicht. Het bevat jouw medische gegevens,\nafkomstig van zorgaanbieders die jij hebt toegevoegd. Jij bent zelf verantwoordelijk voor wat je\nmet deze informatie doet. De gegevens zijn niet gecontroleerd op juistheid of volledigheid."
		expect(pdfData?.tables.isEmpty) == true
	}
	
	@MainActor func test_map_withSubCategory() throws {
		
		// Given
		
		// When
		let pdfData = sut.map(.medication, data: [Generator.healthSubCategory()])
		
		// Then
		expect(pdfData) != nil
		expect(pdfData?.heading) == "Medicijnen"
		expect(pdfData?.subHeading) == "Opgeslagen op 14 nov 2023 om 23:13 uur"
		expect(pdfData?.footer) == "Dit document is gemaakt met Mijn Gezondheidsoverzicht. Het bevat jouw medische gegevens,\nafkomstig van zorgaanbieders die jij hebt toegevoegd. Jij bent zelf verantwoordelijk voor wat je\nmet deze informatie doet. De gegevens zijn niet gecontroleerd op juistheid of volledigheid."
		expect(pdfData?.tables).to(haveCount(1))
		
		let groupedTables = try XCTUnwrap(pdfData?.tables.first)
		expect(groupedTables.heading) == "heading subcategory"
		expect(groupedTables.tables).to(haveCount(1))
		
		let table: PdfTable = try XCTUnwrap(groupedTables.tables.first)
		expect(table.heading) == "heading"
		expect(table.subTables).to(haveCount(2))
		
		var subTable = try XCTUnwrap(table.subTables.first)
		expect(subTable.heading) == "Section Header first group"
		expect(subTable.data).to(haveCount(2))
		
		subTable = try XCTUnwrap(table.subTables.last)
		expect(subTable.heading) == "Section Header second group"
		expect(subTable.data).to(haveCount(4))
	}
}
