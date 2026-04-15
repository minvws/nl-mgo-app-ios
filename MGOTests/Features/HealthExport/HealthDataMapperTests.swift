/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
import MGOUI
import PdfExport
@testable import MGO

@MainActor
@Suite(.serialized)
struct HealthDataMapperTests {

	/// Fixed date matching the test spy: Sunday, 15 June 2025 15:06:40 UTC
	private static let fixedDate = Date(timeIntervalSince1970: 1750000000)

	private var sut: HealthDataMapper

	init() {
		sut = HealthDataMapper(now: { Self.fixedDate })
	}

	@Test("map with empty blocks returns PdfData with correct heading and empty tables")
	func map_withoutSubcategories() {

		// When
		let pdfData = sut.map("Medicijnen", blocks: [])

		// Then
		#expect(pdfData.heading == "Medicijnen")
		#expect(pdfData.subHeading == "Gemaakt op 15 jun 2025 om 17:06 uur")
		#expect(pdfData.footer == "Dit document is gemaakt met Mijn Gezondheidsoverzicht. Het bevat uw medische gegevens,\nvan zorgaanbieders die u heeft toegevoegd. U bent zelf verantwoordelijk voor wat u\nmet deze informatie doet. Er is niet gecontroleerd of de gegevens juist of compleet zijn.")
		#expect(pdfData.tables.isEmpty == true)
	}

	@Test("map with one block returns correct nested PdfData structure")
	func map_withSubCategory() throws {

		// Given
		let block = Generator.healthCategoryBlock()

		// When
		let pdfData = sut.map("Medicijnen", blocks: [block])

		// Then
		#expect(pdfData.heading == "Medicijnen")
		#expect(pdfData.subHeading == "Gemaakt op 15 jun 2025 om 17:06 uur")
		#expect(pdfData.footer == "Dit document is gemaakt met Mijn Gezondheidsoverzicht. Het bevat uw medische gegevens,\nvan zorgaanbieders die u heeft toegevoegd. U bent zelf verantwoordelijk voor wat u\nmet deze informatie doet. Er is niet gecontroleerd of de gegevens juist of compleet zijn.")
		try #require(pdfData.tables.count == 1)

		let groupedTables = try #require(pdfData.tables.first)
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

	@Test("map with healthUISchema returns correct nested PdfData structure")
	func map_healthUISchema() throws {

		// Given
		let schema = Generator.healthUISchema()

		// When
		let pdfData = sut.map(schema)

		// Then
		#expect(pdfData.heading == "UI Schema")
		#expect(pdfData.subHeading == "Gemaakt op 15 jun 2025 om 17:06 uur")
		#expect(pdfData.footer == "Dit document is gemaakt met Mijn Gezondheidsoverzicht. Het bevat uw medische gegevens,\nvan zorgaanbieders die u heeft toegevoegd. U bent zelf verantwoordelijk voor wat u\nmet deze informatie doet. Er is niet gecontroleerd of de gegevens juist of compleet zijn.")
		try #require(pdfData.tables.count == 3)

		// tables[0] — Section Header first group (6 UIElements → 6 subTables)
		let group0 = pdfData.tables[0]
		#expect(group0.heading == "Section Header first group")
		#expect(group0.shouldStartOnNewPage == false)
		try #require(group0.tables.count == 1)
		let table0 = group0.tables[0]
		#expect(table0.heading == nil)
		try #require(table0.subTables.count == 6)
		#expect(table0.subTables[0].data.count == 1) // singleValue with display
		#expect(table0.subTables[0].data[0].key == "label single value")
		#expect(table0.subTables[0].data[0].value == "single value")
		#expect(table0.subTables[1].data.isEmpty) // referenceValue, display nil
		#expect(table0.subTables[2].data.isEmpty) // referenceValue, display nil
		#expect(table0.subTables[3].data.count == 1) // referenceLink
		#expect(table0.subTables[3].data[0].key == "label reference link")
		#expect(table0.subTables[3].data[0].value == "reference")
		#expect(table0.subTables[4].data.count == 1) // downloadLink
		#expect(table0.subTables[4].data[0].value == "label download link")
		#expect(table0.subTables[4].data[0].style == .download)
		#expect(table0.subTables[5].data.count == 1) // downloadBinary
		#expect(table0.subTables[5].data[0].value == "label download reference")
		#expect(table0.subTables[5].data[0].style == .download)

		// tables[1] — Section Header second group (4 UIElements → 4 subTables)
		let group1 = pdfData.tables[1]
		#expect(group1.heading == "Section Header second group")
		#expect(group1.shouldStartOnNewPage == false)
		try #require(group1.tables.count == 1)
		let table1 = group1.tables[0]
		#expect(table1.heading == nil)
		try #require(table1.subTables.count == 4)
		#expect(table1.subTables[0].data.isEmpty) // singleValue with nil value
		#expect(table1.subTables[1].data.count == 1) // multipleGroupedValues
		#expect(table1.subTables[1].data[0].value == "five\nsix")
		#expect(table1.subTables[2].data.count == 1) // multipleValues (one, two)
		#expect(table1.subTables[2].data[0].value == "one\ntwo")
		#expect(table1.subTables[3].data.count == 1) // multipleValues (one)
		#expect(table1.subTables[3].data[0].value == "one")

		// tables[2] — Section Header third group (3 UIElements → 3 subTables)
		let group2 = pdfData.tables[2]
		#expect(group2.heading == "Section Header third group")
		#expect(group2.shouldStartOnNewPage == false)
		try #require(group2.tables.count == 1)
		let table2 = group2.tables[0]
		#expect(table2.heading == nil)
		try #require(table2.subTables.count == 3)
		#expect(table2.subTables[0].data.count == 1) // singleValue with code/display
		#expect(table2.subTables[0].data[0].value == "display")
		#expect(table2.subTables[1].data.count == 1) // multipleValues with code/display
		#expect(table2.subTables[1].data[0].value == "display")
		#expect(table2.subTables[2].data.count == 1) // multipleGroupedValues with code/display
		#expect(table2.subTables[2].data[0].value == "display")
	}
}
