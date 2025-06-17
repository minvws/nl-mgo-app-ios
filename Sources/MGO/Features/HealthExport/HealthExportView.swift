/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOFoundation
import MGOUI
import PDFKit

// swiftlint:disable type_body_length
class HealthExportViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The organization to show the categories for (optional, if nil, then show all organizations)
	private var organization: MgoOrganization?
	
	/// The category to show
	private var category: HealthCategories.Category
	
	/// The factory that creates the draw elements
	private var factory: PdfDrawElementFactory!
	
	/// the export theme
	private var theme: ExportTheme = .init()
	
	/// The state of the view
	enum State: Equatable {
		
		/// The data is being loading
		case loading
		
		/// the document is generated
		case document(PDFDocument)
	}
		
	@Published var state: State = .loading
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case onAppear
		case safePdf
	}
	
	/// Create a Health category view model
	/// - Parameter coordinator: the app coordinator
	init(
		coordinator: (any Coordinator)? = nil,
		category: HealthCategories.Category,
		organization: MgoOrganization?
	) {
		self.coordinator = coordinator
		self.category = category
		self.organization = organization
		self.state = .loading
		
		// The factory for all the PDF draw elements
		factory = PdfDrawElementFactory(theme: theme)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthExportViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			
			case .onAppear:
				generatePDF(source: source())
			
			case .safePdf:
				if case let .document(pDFDocument) = state {
					if let data = pDFDocument.dataRepresentation() {
						let url = savePDF(data: data, fileName: "Rool voor de zorg")
						logDebug("Saving PDF", url as Any)
					}
				}
		}
	}
	
	func source() -> PdfData {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		
		let timeFormatter = DateFormatter()
		timeFormatter.dateStyle = .none
		timeFormatter.timeStyle = .short
		
		let date = Date()
		
		return PdfData(
			heading: "Medische hulpmiddelen",
			subHeading: String(format: String(localized: "export_pdf.subheading"), arguments: [dateFormatter.string(from: date), timeFormatter.string(from: date)]),
			tables: [
				PdfGroupedTables(
					heading: "Grouped Table #1",
					tables: [
						PdfTable(
							heading: "Table Heading #1",
							subTables: [
								PdfSubTable(
									heading: "Table Sub Heading #1",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								)
							]
						)
					]
				),
				PdfGroupedTables(
					heading: "Grouped Table #2",
					tables: [
						PdfTable(
							heading: "Table Heading #2",
							subTables: [
								PdfSubTable(
									heading: nil,
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								)
							]
						),
						PdfTable(
							heading: "Table Heading #3",
							subTables: [
								PdfSubTable(
									heading: "Table Sub Heading #3",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								),
								PdfSubTable(
									heading: "Table Sub Heading #4",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								)
							]
						),
						PdfTable(
							heading: "Table Heading #4",
							subTables: [
								PdfSubTable(
									heading: "Table Sub Heading #3",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								),
								PdfSubTable(
									heading: "Table Sub Heading #4",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								)
							]
						),
						PdfTable(
							heading: "Table Heading #5",
							subTables: [
								PdfSubTable(
									heading: "Table Sub Heading #3",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								),
								PdfSubTable(
									heading: "Table Sub Heading #4",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								)
							]
						),
						PdfTable(
							heading: "Table Heading #6",
							subTables: [
								PdfSubTable(
									heading: "Table Sub Heading #3",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								),
								PdfSubTable(
									heading: "Table Sub Heading #4",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								)
							]
						),
						PdfTable(
							heading: "Table Heading #7",
							subTables: [
								PdfSubTable(
									heading: "Table Sub Heading #3",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								),
								PdfSubTable(
									heading: "Table Sub Heading #4",
									data: [
										PdfSubTablePair(key: "Key 1", value: "Value 1"),
										PdfSubTablePair(key: "Key 2", value: "Value 2"),
										PdfSubTablePair(key: "Key 3", value: "Value 3")
									]
								)
							]
						)
						
					]
				)
			],
			footer: String(localized: "export_pdf.footer")
		)
	}
	
	private let metaData = [
		kCGPDFContextAuthor: String(localized: "common.app_name"),
		kCGPDFContextSubject: String(localized: "export_pdf.footer")
	]
	
	enum Constants {
		static let pageWidth: CGFloat = 595.28 // A4 Paper Size
		static let pageHeight: CGFloat = 841.89 // A4 Paper Size
		static let outerMargin: CGFloat = 28
		static let innerMargin: CGFloat = 16
		
		// The width and height we can draw on. (i.e. apply the outer margins)
		static let contentSize = CGSize(
			width: Constants.pageWidth - 2 * Constants.outerMargin,
			height: Constants.pageHeight - 2 * Constants.outerMargin
		)
	}
	
	/// Generate the PDF
	/// - Parameter source: the data source
	@MainActor private func generatePDF(source: PdfData) {
		
		// Our pointer to the position where we should draw the next element
		var currentY: CGFloat = Constants.outerMargin
		
		// The array with all the draw elements we are creating
		var drawElements = [PdfDrawElement]()
		
		// Footer, reusable
		let footer = factory.createFooterElement(source)
		
		// What is the height we have for our tables? the content height minus footer minus the margins.
		let availableHeight = Constants.contentSize.height - footer.height - Constants.innerMargin

		// We should always start with a page break
		drawElements.append(PdfDrawElement.pageBreak)
		
		// The heading and sub heading on the first page
		drawElements.append(factory.createPdfSubHeadingDrawElement(source, currentY: currentY))
		currentY += drawElements.last?.height ?? 0
		drawElements.append(factory.createPdfHeadingDrawElement(source, currentY: currentY))
		currentY += drawElements.last?.height ?? 0

		// Padding between heading and tables
		currentY += Constants.innerMargin
		
		source.tables.forEach({ groupedTable in
			
			// Grouped Table
			var groupTableDrawElement = factory.createGroupedHeadingDrawElement(groupedTable, currentY: currentY)
			if currentY + groupTableDrawElement.height > availableHeight {
				drawElements.append(PdfDrawElement.pageBreak)
				currentY = Constants.outerMargin
				groupTableDrawElement.rect.origin.y = currentY
			}
			drawElements.append(groupTableDrawElement)
			currentY += drawElements.last?.height ?? 0
			
			groupedTable.tables.forEach({ table in
				
				// Table
				var tableDrawElement = factory.createTableHeadingDrawElement(table, currentY: currentY)
				if currentY + tableDrawElement.height > availableHeight {
					drawElements.append(PdfDrawElement.pageBreak)
					currentY = Constants.outerMargin
					tableDrawElement.rect.origin.y = currentY
				}
				drawElements.append(tableDrawElement)
				currentY += drawElements.last?.height ?? 0
				
				table.subTables.forEach({ subTable in
					
					// Subtables
					if let heading = subTable.heading {
						
						var subTableHeadingDrawElement = factory.createSubTableHeadingDrawElement(heading: heading, currentY: currentY)
						if currentY + subTableHeadingDrawElement.height > availableHeight {
							drawElements.append(PdfDrawElement.pageBreak)
							currentY = Constants.outerMargin
							subTableHeadingDrawElement.rect.origin.y = currentY
						}
						drawElements.append(subTableHeadingDrawElement)
						currentY += drawElements.last?.height ?? 0
					}
					
					subTable.data.forEach({ pair in
						
						var rowDrawElements = factory.createSubTableRowDrawElement(pair, currentY: currentY)
						
						if currentY + (rowDrawElements.last?.height ?? 0) > availableHeight {
							drawElements.append(PdfDrawElement.pageBreak)
							currentY = Constants.outerMargin
							if rowDrawElements.count == 2 {
								rowDrawElements[0].rect.origin.y = currentY
								rowDrawElements[1].rect.origin.y = currentY
							}
						}
						
						drawElements.append(contentsOf: rowDrawElements)
						currentY += drawElements.last?.height ?? 0
					})
					
				})
				
				// Padding between tables
				currentY += Constants.innerMargin
				
			})
			
			// New Page after Grouped Table (except the last one)
			if groupedTable != source.tables.last {
				drawElements.append(PdfDrawElement.pageBreak)
				currentY = Constants.outerMargin
			}
			
		})
		
		// Start drawing
		drawPDF(drawElements, footer: footer)
	}
	
	/// Draw all the elements in a PDF
	/// - Parameters:
	///   - elements: the elements to draw (should start with a page break)
	///   - footer: the footer for each page
	///   - contentSize: the content size
	@MainActor func drawPDF(_ elements: [PdfDrawElement], footer: PdfDrawElement) {
		
		let format = UIGraphicsPDFRendererFormat()
		format.documentInfo = metaData as [String: Any]

		// The engine to render the PDF
		let pdfRenderer = UIGraphicsPDFRenderer(
			bounds: CGRect(x: 0, y: 0, width: Constants.pageWidth, height: Constants.pageHeight),
			format: format
		)
		
		var currentPage: Int = 0
		let totalPages: Int = elements.filter { $0.isPageBreak == true }.count
		
		let data = pdfRenderer.pdfData { context in
			
			// Loop over all the elements and draw them
			elements.forEach { drawElement in
				
				if drawElement.isPageBreak {
					// Draw the page break
					handlePageBreak(
						context,
						currentPage: &currentPage,
						totalPages: totalPages,
						footer: footer
					)
				}
				
				// Draw the pdf element onto the canvas
				drawElement.draw(context)
			}
		}
		
		// Update State
		if let document = PDFDocument(data: data) {
			state = .document(document)
		}
	}
	
	/// Handle the page break
	/// - Parameters:
	///   - context: The drawing environment for a PDF renderer.
	///   - currentPage: the page we are currently drawing on
	///   - totalPages: the total number of pages
	///   - footer: the footer for each page
	@MainActor private func handlePageBreak(
		_ context: UIGraphicsPDFRendererContext,
		currentPage: inout Int,
		totalPages: Int,
		footer: PdfDrawElement,
	) {
		
		// We should draw a new page
		context.beginPage()

		// Increase page number
		currentPage += 1
		
		// draw footer
		footer.draw(context)
		
		// draw pagination
		factory.createPaginationElement(
			currentPage: currentPage,
			totalPages: totalPages
		).draw(context)
	}
	
	@MainActor func savePDF(data: Data, fileName: String) -> URL? {
		let fileManager = FileManager.default
		guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
			return nil
		}
		let fileURL = documentDirectory.appendingPathComponent("\(fileName).pdf")
		
		do {
			try data.write(to: fileURL)
			return fileURL
		} catch {
			logError("Error saving PDF: \(error.localizedDescription)")
			return nil
		}
	}
}
// swiftlint:enable type_body_length

struct HealthExportView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthExportViewModel
	
	/// The Theme
	@Environment(\.theme) var theme

	var body: some View {
		
		VStack {
			
			switch viewModel.state {
				case .loading:
					Text("Loading")
					
				case .document(let pDFDocument):
				
					Button("Save PDF") {
						viewModel.reduce(.safePdf)
					}
				
					PDFKitView(pDFDocument)
			}
		}
		.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
}
