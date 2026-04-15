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
				],
				shouldStartOnNewPage: false
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
				],
				shouldStartOnNewPage: true
			),
			PdfGroupedTables(
				heading: "Group #3",
				tables: [],
				shouldStartOnNewPage: true
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
	
	@Test("savePDF sanitizes slashes and colons in category name")
	func savePDF_sanitizesSpecialCharacters() throws {

		// Given
		let specialData = PdfData(heading: "Bloed/Druk: meting", subHeading: "", tables: [], footer: "")
		let vm = HealthExportViewModel(coordinator: coordinatorSpy, healthData: specialData)

		// When
		let url = try #require(vm.savePDF(data: Data([0x25, 0x50, 0x44, 0x46]))) // minimal %PDF header
		let filename = url.lastPathComponent

		// Then — no slashes or colons in the filename
		#expect(!filename.contains("/"))
		#expect(!filename.contains(":"))
		try? FileManager.default.removeItem(at: url)
	}

	@Test("savePDF collapses consecutive illegal characters into a single underscore")
	func savePDF_collapsesConsecutiveIllegalCharacters() throws {

		// Given
		let specialData = PdfData(heading: "A//B::C", subHeading: "", tables: [], footer: "")
		let vm = HealthExportViewModel(coordinator: coordinatorSpy, healthData: specialData)

		// When
		let url = try #require(vm.savePDF(data: Data([0x25, 0x50, 0x44, 0x46])))
		let filename = url.lastPathComponent

		// Then — consecutive illegal chars become a single underscore
		#expect(filename.contains("a_b_c"))
		try? FileManager.default.removeItem(at: url)
	}

	@Test("Tapping back calls coordinator with backButtonPressed")
	func backButtonPressed() async {
		
		// Given
		
		// When
		await sut.reduce(.backButtonPressed)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.backButtonPressed)
	}
	
	@Test("Tapping close calls coordinator with closeSheet")
	func closeSheet() async {
		
		// Given
		
		// When
		await sut.reduce(.closeSheet)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.closeSheet)
	}
	
	@Test("onAppear generates the PDF and saves it to disk")
	func onAppear() async throws {

		// Given

		// When
		await sut.reduce(.onAppear)

		// Then
		#expect(coordinatorSpy.invokedHandle == false)
		let pdfUrl = try #require(sut.pdfUrl)
		let data = try #require(FileManager.default.contents(atPath: pdfUrl.path))
		#expect(data.isEmpty == false)
		try? FileManager.default.removeItem(atPath: pdfUrl.path)
	}

	@Test("Second onAppear is a no-op when PDF is already generated")
	func onAppear_idempotent() async throws {
		// Given — first appearance generates the PDF
		await sut.reduce(.onAppear)
		let firstUrl = try #require(sut.pdfUrl)

		// When — second appearance (view re-presented)
		await sut.reduce(.onAppear)

		// Then — pdfUrl unchanged, PDF was not re-generated
		#expect(sut.pdfUrl == firstUrl)
		try? FileManager.default.removeItem(at: firstUrl)
	}

	@Test("generatePDF returns nil when the task is cancelled before rendering")
	func generatePDF_cancelledBeforeRendering() async {

		// Given — empty tables so the layout loop has zero iterations and no existing
		// isCancelled check fires; only the guard before makePDFDocument can catch this.
		let emptyData = PdfData(heading: "Test", subHeading: "", tables: [], footer: "")
		let generator = HealthExportPdfGenerator(dataSource: emptyData)

		// When — cancel the task before it gets a chance to run.
		// PDFDocument is not Sendable, so the nil check stays inside the task.
		let task = Task { await generator.generatePDF() == nil }
		task.cancel()
		let resultIsNil = await task.value

		// Then
		#expect(resultIsNil)
	}

	@Test("safePdf triggers sharing without updating pdfUrl")
	func safePdf() async {
		
		// Given
		await sut.generatePDF()
		
		// When
		await sut.reduce(.safePdf)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == false)
		#expect(sut.pdfUrl == nil)
		#expect(sut.presentSharing == true)
	}
}
