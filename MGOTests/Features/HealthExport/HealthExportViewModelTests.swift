/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOTest
import MGOFoundation
import MGOUI
import PdfExport
@testable import MGO

final class HealthExportViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: HealthExportViewModel!
	
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
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		sut = HealthExportViewModel(
			coordinator: coordinatorSpy,
			healthData: HealthExportViewModelTests.pdfData
		)
	}
	
	@MainActor func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}

	@MainActor func test_closeSheet_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	@MainActor func test_onAppear_shouldSavePDF() throws {
		
		// Given
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.pdfUrl).toEventuallyNot(beNil())
		
		let pdfUrl = try XCTUnwrap(sut.pdfUrl)
		let data = FileManager.default.contents(atPath: pdfUrl.path)
		expect(data?.count) == 13726
		try? FileManager.default.removeItem(atPath: pdfUrl.path)
	}
}
