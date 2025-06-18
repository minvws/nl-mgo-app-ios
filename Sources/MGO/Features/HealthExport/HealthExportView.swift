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
	
	/// The state of the view, defaults to loading
	@Published var state: State = .loading
	
	/// The title of the page (the category name)
	@Published var title: LocalizedStringKey
	
	/// The path to the generated pdf
	@Published var pdfUrl: URL?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case closeSheet
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
		self.title = category.heading
		
		// The factory for all the PDF draw elements
		factory = PdfDrawElementFactory(theme: theme)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthExportViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
			
			case .onAppear:
				generatePDF(source: source())
			
				if case let .document(pDFDocument) = state, !isIOS15 {
					if let data = pDFDocument.dataRepresentation(),
					   let url = savePDF(data: data, fileName: "Rool_voor_de_zorg") {
						logDebug("Saving PDF onAppear", url as Any)
						pdfUrl = url
					}
				}
			
			case .safePdf:
				if case let .document(pDFDocument) = state {
					if let data = pDFDocument.dataRepresentation(),
					   let url = savePDF(data: data, fileName: "Rool_voor_de_zorg") {
						logDebug("Saving PDF on safePdf", url as Any)
						shareDocument(url)
					}
				}
		}
	}
	
	@MainActor private func shareDocument(_ url: URL) {
		
		guard let vc = UIApplication.shared.firstKeyWindow?.rootViewController else { return }
		
		let shareActivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		shareActivity.popoverPresentationController?.sourceView = vc.view
		shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
		shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
		vc.present(shareActivity, animated: true, completion: nil)
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
		kCGPDFContextSubject: String(localized: "export_pdf.footer"),
		kCGPDFContextAllowsPrinting: true,
		kCGPDFContextAllowsCopying: true
	] as [CFString: Any]
	
	/// Generate the PDF
	/// - Parameter source: the data source
	@MainActor private func generatePDF(source: PdfData) {
		
		// Our pointer to the position where we should draw the next element
		var currentY: CGFloat = HealthExport.Constants.outerMargin
		
		// The array with all the draw elements we are creating
		var drawElements = [PdfDrawElement]()
		
		// Footer, reusable
		let footer = factory.createFooterElement(source)
		
		// What is the height we have for our tables? the content height minus footer minus the margins.
		let availableHeight = HealthExport.Constants.contentSize.height - footer.height - HealthExport.Constants.innerMargin

		// We should always start with a page break
		drawElements.append(PdfDrawElement.pageBreak)
		
		// The heading and sub heading on the first page
		drawElements.append(factory.createPdfSubHeadingDrawElement(source, currentY: currentY))
		currentY += drawElements.last?.height ?? 0
		drawElements.append(factory.createPdfHeadingDrawElement(source, currentY: currentY))
		currentY += drawElements.last?.height ?? 0

		// Padding between heading and tables
		currentY += HealthExport.Constants.innerMargin
		
		source.tables.forEach({ groupedTable in
			
			// Grouped Table
			var groupTableDrawElement = factory.createGroupedHeadingDrawElement(groupedTable, currentY: currentY)
			if currentY + groupTableDrawElement.height > availableHeight {
				drawElements.append(PdfDrawElement.pageBreak)
				currentY = HealthExport.Constants.outerMargin
				groupTableDrawElement.rect.origin.y = currentY
			}
			drawElements.append(groupTableDrawElement)
			currentY += drawElements.last?.height ?? 0
			
			groupedTable.tables.forEach({ table in
				
				// Table
				var tableDrawElement = factory.createTableHeadingDrawElement(table, currentY: currentY)
				if currentY + tableDrawElement.height > availableHeight {
					drawElements.append(PdfDrawElement.pageBreak)
					currentY = HealthExport.Constants.outerMargin
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
							currentY = HealthExport.Constants.outerMargin
							subTableHeadingDrawElement.rect.origin.y = currentY
						}
						drawElements.append(subTableHeadingDrawElement)
						currentY += drawElements.last?.height ?? 0
					}
					
					subTable.data.forEach({ pair in
						
						var rowDrawElements = factory.createSubTableRowDrawElement(pair, currentY: currentY)
						
						if currentY + (rowDrawElements.last?.height ?? 0) > availableHeight {
							drawElements.append(PdfDrawElement.pageBreak)
							currentY = HealthExport.Constants.outerMargin
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
				currentY += HealthExport.Constants.innerMargin
				
			})
			
			// New Page after Grouped Table (except the last one)
			if groupedTable != source.tables.last {
				drawElements.append(PdfDrawElement.pageBreak)
				currentY = HealthExport.Constants.outerMargin
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
			bounds: CGRect(x: 0, y: 0, width: HealthExport.Constants.pageWidth, height: HealthExport.Constants.pageHeight),
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
	
	/// Save the document
	/// - Parameters:
	///   - data: the pdf in binary
	///   - fileName: the name of the file
	/// - Returns: url to the saved file.
	@MainActor func savePDF(data: Data, fileName: String) -> URL? {
		
		let fileManager = FileManager.default
		guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
			return nil
		}
		var fileURL = documentDirectory
			.appendingPathComponent("export", isDirectory: true)
		
		if !fileManager.fileExists(atPath: fileURL.path) {
			do {
				try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
			} catch {
				logError(error.localizedDescription)
				return nil
			}
		}
		
		fileURL = fileURL
			.appendingPathComponent("\(fileName)")
			.appendingPathExtension("pdf")
		
		fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)
		return fileURL
	}
}
// swiftlint:enable type_body_length

struct HealthExportView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthExportViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Icon {
			static let size: CGFloat = 28
		}
	}
	
	/// Get the view for the export
	var body: some View {
		
		VStack {
			
			switch viewModel.state {
				case .loading:
				
					Spacer()
					
					ProgressView("pdf_viewer.loading")
						.foregroundStyle(theme.contentSecondary)
						.rijksoverheidStyle(font: .regular, style: .body)
				
					Spacer()
					
				case .document(let pdfDocument):
					
					PDFKitView(pdfDocument)
						.padding(.horizontal, ViewTraits.General.padding)
					
					if #available(iOS 16.0, *) {
						if let pdfUrl = viewModel.pdfUrl {
							HStack {
								ShareLink(item: pdfUrl) {
									Image(systemName: "square.and.arrow.up")
										.resizable()
										.scaledToFit()
										.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size)
								}
								.accessibilityLabel("export_pdf.share")
								.accessibilityIdentifier("export_pdf.share")
								Spacer()
							}
							.padding(.horizontal, ViewTraits.General.padding)
							.padding(.top, ViewTraits.General.padding)
							.background(theme.backgroundSecondary)
						}
					}
			}
		}
		.frame(maxWidth: .infinity)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.navigationTitle(viewModel.title)
		.navigationBarBackButtonHidden()
		.layoutForIPad()
		.when(isPresentedAsSheet, transform: { view in
			view
				.toolbar(content: close)
		})
		.when(!isPresentedAsSheet, transform: { view in
			view
				.toolbar(content: shareTopBarTrailing)
				.navigationBarItems(leading: BackButton {
					viewModel.reduce(.backButtonPressed)
				})
				.navigationBarTitleDisplayMode(.inline)
		})
		
	}
	
	/// Content for the close button toolbar
	/// - Returns: the close button in a toolbar
	@ToolbarContentBuilder private func close() -> some ToolbarContent {
		ToolbarItemGroup(
			placement: .topBarTrailing,
			content: {
				Button("export_pdf.close") {
					viewModel.reduce(.closeSheet)
				}
				.buttonStyle(ToolbarButtonStyle())
				.accessibilityIdentifier("export_pdf.close")
			}
		)
	}
	
	/// Content for the share button toolbar
	/// - Returns: the share button in a toolbar
	@ToolbarContentBuilder private func shareTopBarTrailing() -> some ToolbarContent {
		ToolbarItemGroup(
			placement: .topBarTrailing,
			content: {
				Button {
					viewModel.reduce(.safePdf)
				} label: {
					Image(systemName: "square.and.arrow.up")
				}
				.accessibilityLabel("export_pdf.share")
				.accessibilityIdentifier("export_pdf.share")
				
			}
		)
	}
}
