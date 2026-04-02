/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOTest
import MGOFoundation
import MGOUI
import PdfExport
@testable import MGO

@MainActor
@Suite
struct HealthExportViewModelTests {
	
	private let coordinatorSpy: DashboardCoordinatorSpy
	private let servicesSpies: ServicesSpies
	private let sut: HealthExportViewModel
	
	static let pdfData = PdfData(
		heading: "PDF Test Heading",
		subHeading: "Sub Heading",
		tables: [
			PdfGroupedTables(
				heading: "Group #1",
				tables: [
					PdfTable(
						heading: "Table #1",
						subTables: [
							PdfSubTable(
								heading: nil,
								data: [
									PdfSubTablePair(key: "Key 1", value: "Value 1"),
									PdfSubTablePair(key: "Key 2", value: "Value 2")
								]
							),
							PdfSubTable(
								heading: "Subtable #2",
								data: [
									PdfSubTablePair(key: "Key 3", value: "Value 3"),
									PdfSubTablePair(key: "Key 4", value: "Value 4")
								]
							)
						]
					),
					PdfTable(
						heading: "Table #1",
						subTables: [
							PdfSubTable(
								heading: nil,
								data: [
									PdfSubTablePair(key: "Key 1", value: "Value 1"),
									PdfSubTablePair(key: "Key 2", value: "Value 2")
								]
							),
							PdfSubTable(
								heading: "Subtable #2",
								data: [
									PdfSubTablePair(key: "Key 3", value: "Value 3"),
									PdfSubTablePair(key: "Key 4", value: "Value 4")
								]
							)
						]
					)
				]
			),
			PdfGroupedTables(
				heading: "Group #2",
				tables: [
					PdfTable(
						heading: "Table #2",
						subTables: [
							PdfSubTable(
								heading: nil,
								data: [
									PdfSubTablePair(key: "Key 1", value: "Value 1"),
									PdfSubTablePair(key: "Key 2", value: "Value 2")
								]
							),
							PdfSubTable(
								heading: "Subtable #2",
								data: [
									PdfSubTablePair(key: "Key 3", value: "Value 3"),
									PdfSubTablePair(key: "Key 4", value: "Value 4")
								]
							)
						]
					)
				]
			),
			PdfGroupedTables(
				heading: "Group #3",
				tables: []
			)
		],
		footer: "footer"
	)
	
	init() {
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		sut = HealthExportViewModel(
			coordinator: coordinatorSpy,
			healthData: HealthExportViewModelTests.pdfData
		)
	}
	
	@Test("Tapping back calls coordinator with backButtonPressed")
	func backButtonPressed() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.backButtonPressed)
	}
	
	@Test("Tapping close calls coordinator with closeSheet")
	func closeSheet() {

		// Given
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.closeSheet)
	}
	
	@Test("onAppear generates the PDF and saves it to disk")
	func onAppear() throws {

		// Given
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == false)
		let pdfUrl = try #require(sut.pdfUrl)
		let data = FileManager.default.contents(atPath: pdfUrl.path)
		#expect(abs(Double(data?.count ?? 0) - 14084) <= 10)
		try? FileManager.default.removeItem(atPath: pdfUrl.path)
	}
	
	@Test("safePdf triggers sharing without updating pdfUrl")
	func safePdf() {
		
		// Given
		sut.generatePDF()
		
		// When
		sut.reduce(.safePdf)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == false)
		#expect(sut.pdfUrl == nil)
		#expect(sut.presentSharing == true)
	}
}
