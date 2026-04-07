/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOTest
import MGOFoundation
import MGOUI
import PdfExport
@testable import MGO

@MainActor
@Suite(.serialized)
struct HealthDataMapperTests {

	private var servicesSpies: ServicesSpies
	private var sut: HealthDataMapper

	init() {
		servicesSpies = setupServicesSpies()
		sut = HealthDataMapper()
	}

	@Test("map with empty blocks returns PdfData with correct heading and empty tables")
	func map_withoutSubcategories() {
		
		// Given
		let pdfData = sut.map("Medicijnen", blocks: [])
		
		// When
		
		// Then
		#expect(pdfData != nil)
		#expect(pdfData?.heading == "Medicijnen")
		#expect(pdfData?.subHeading == "Gemaakt op 15 jun 2025 om 17:06 uur")
		#expect(pdfData?.footer == "Dit document is gemaakt met Mijn Gezondheidsoverzicht. Het bevat uw medische gegevens,\nvan zorgaanbieders die u heeft toegevoegd. U bent zelf verantwoordelijk voor wat u\nmet deze informatie doet. Er is niet gecontroleerd of de gegevens juist of compleet zijn.")
		#expect(pdfData?.tables.isEmpty == true)
	}

	@Test("map with one block returns correct nested PdfData structure")
	func map_withSubCategory() throws {

		// Given
		let pdfData = sut.map(
			"Medicijnen",
			blocks: [Generator.healthCategoryBlock()]
		)

		// When
		
		// Then
		let unwrappedData = try #require(pdfData)
		#expect(unwrappedData.heading == "Medicijnen")
		#expect(unwrappedData.subHeading == "Gemaakt op 15 jun 2025 om 17:06 uur")
		#expect(unwrappedData.footer == "Dit document is gemaakt met Mijn Gezondheidsoverzicht. Het bevat uw medische gegevens,\nvan zorgaanbieders die u heeft toegevoegd. U bent zelf verantwoordelijk voor wat u\nmet deze informatie doet. Er is niet gecontroleerd of de gegevens juist of compleet zijn.")
		try #require(unwrappedData.tables.count == 1)
		
		let groupedTables = try #require(unwrappedData.tables.first)
		#expect(groupedTables.heading == "heading subcategory")
		try #require(groupedTables.tables.count == 1)
		
		let table = try #require(groupedTables.tables.first)
		#expect(table.heading == "heading")
		try #require(table.subTables.count == 3)
		
		let subTable0 = table.subTables[0]
		#expect(subTable0.heading == "Section Header first group")
		#expect(subTable0.data.count == 4)
		
		let subTable1 = table.subTables[1]
		#expect(subTable1.heading == "Section Header second group")
		#expect(subTable1.data.count == 3)
		
		let subTable2 = table.subTables[2]
		#expect(subTable2.heading == "Section Header third group")
		#expect(subTable2.data.count == 3)
	}
}
