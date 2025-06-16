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
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthExportViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			
			case .onAppear:
				generatePDF()
			
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
	}
	
	@MainActor private func generatePDF() {
		
		let contentWidth = Constants.pageWidth - 2 * Constants.outerMargin
		let contentHeight = Constants.pageHeight - 2 * Constants.outerMargin
		var currentY: CGFloat = Constants.outerMargin
		var drawElements = [PdfDrawElement]()
		
		let source = source()
		
		// Footer, reusable
		let footer = createPdfFooter(
			footer: source.footer,
			height: contentHeight,
			width: contentWidth
		)
		
		let workableHeight = contentHeight - Constants.outerMargin - footer.height - Constants.innerMargin

		// Page break
		drawElements.append(PdfDrawElement.pageBreak)
		
		// The header on the first page
		drawElements.append(
			createPdfSubHeading(
				subHeading: source.subHeading,
				currentY: currentY,
				width: contentWidth
			)
		)
		currentY += drawElements.last?.height ?? 0
		
		drawElements.append(
			createPdfHeading(
				heading: source.heading,
				currentY: currentY,
				width: contentWidth
			)
		)
		currentY += drawElements.last?.height ?? 0
		
		currentY += Constants.innerMargin
		
		source.tables.forEach({ groupedTable in
			
			// Grouped Table
			var groupTableDrawElement = createGroupedHeading(heading: groupedTable.heading, currentY: currentY, width: contentWidth)
			if currentY + groupTableDrawElement.height > workableHeight {
				drawElements.append(PdfDrawElement.pageBreak)
				currentY = Constants.outerMargin
				groupTableDrawElement.rect.origin.y = currentY
			}
			drawElements.append(groupTableDrawElement)
			currentY += drawElements.last?.height ?? 0
			
			groupedTable.tables.forEach({ table in
				
				// Table
				var tableDrawElement = createTableHeading(heading: table.heading, currentY: currentY, width: contentWidth)
				if currentY + tableDrawElement.height > workableHeight {
					drawElements.append(PdfDrawElement.pageBreak)
					currentY = Constants.outerMargin
					tableDrawElement.rect.origin.y = currentY
				}
				drawElements.append(tableDrawElement)
				currentY += drawElements.last?.height ?? 0
				
				table.subTables.forEach({ subTable in
					
					// Subtables
					if let heading = subTable.heading {
						
						var subTableHeadingDrawElement = createSubTableHeading(heading: heading, currentY: currentY, width: contentWidth)
						if currentY + subTableHeadingDrawElement.height > workableHeight {
							drawElements.append(PdfDrawElement.pageBreak)
							currentY = Constants.outerMargin
							subTableHeadingDrawElement.rect.origin.y = currentY
						}
						drawElements.append(subTableHeadingDrawElement)
						currentY += drawElements.last?.height ?? 0
					}
					
					subTable.data.forEach({ row in
						
						var rowDrawElements = createSubTableRow(key: row.key, value: row.value, currentY: currentY, width: contentWidth)
						
						if currentY + (rowDrawElements.last?.height ?? 0) > workableHeight {
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
		drawPDF(
			drawElements,
			footer: footer,
			contentSize: CGSize(width: contentWidth, height: contentHeight)
		)
	}
	
	/// Draw all the elements in a PDF
	/// - Parameters:
	///   - elements: the elements to draw (should start with a page break)
	///   - footer: the footer for each page
	///   - contentSize: the content size
	@MainActor func drawPDF(_ elements: [PdfDrawElement], footer: PdfDrawElement, contentSize: CGSize) {
		
		let format = UIGraphicsPDFRendererFormat()
		format.documentInfo = metaData as [String: Any]
		
		let pdfRenderer = UIGraphicsPDFRenderer(
			bounds: CGRect(x: 0, y: 0, width: Constants.pageWidth, height: Constants.pageHeight),
			format: format
		)
		
		var currentPage: Int = 0
		let totalPages: Int = elements.filter { $0.isPageBreak == true }.count
		var currentY: CGFloat = Constants.outerMargin
		
		let data = pdfRenderer.pdfData { context in
			
			elements.forEach { drawElement in
				
				if drawElement.isPageBreak {
					// We should draw a new page
					context.beginPage()
					// Reset pointer
					currentY = Constants.outerMargin
					// Increase page number
					currentPage += 1
					
					// draw footer elements
					footer.draw(context)
					createPagination(
						currentPage: currentPage,
						totalPages: totalPages,
						height: contentSize.height,
						width: contentSize.width
					).draw(context)
				}
				
				// Draw element
				drawElement.draw(context)
				currentY += drawElement.height
			}
		}
		
		if let document = PDFDocument(data: data) {
			state = .document(document)
		}
	}
	
	@MainActor func createPdfHeading(
		heading: String,
		currentY: CGFloat,
		width: CGFloat
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: heading,
			attributes: [
				.font: UIFont(
					name: "Helvetica-Bold",
					size: 24
				) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let textHeight = text.boundingRect(
			with: CGSize(width: width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		).height
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(x: Constants.outerMargin, y: currentY, width: width, height: textHeight),
			height: textHeight
		)
	}
	
	@MainActor func createPdfSubHeading(
		subHeading: String,
		currentY: CGFloat,
		width: CGFloat
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: subHeading,
			attributes: [
				.font: UIFont(
					name: "Helvetica",
					size: 10
				) as Any,
				.foregroundColor: UIColor(theme.secondaryText)
			]
		)
		
		let textBox = text.boundingRect(
			with: CGSize(width: width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		)
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(
				x: Constants.outerMargin + width - textBox.width,
				y: currentY,
				width: textBox.width,
				height: textBox.height
			),
			height: 0
		)
	}
	
	@MainActor func createPdfFooter(
		footer: String,
		height: CGFloat,
		width: CGFloat,
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: footer,
			attributes: [
				.font: UIFont(
					name: "Helvetica",
					size: 10
				) as Any,
				.foregroundColor: UIColor(theme.secondaryText)
			]
		)
		
		let textHeight = text.boundingRect(
			with: CGSize(width: width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		).height
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(
				x: Constants.outerMargin,
				y: height - textHeight,
				width: width,
				height: textHeight
			),
			height: textHeight
		)
	}
	
	@MainActor func createPagination(
		currentPage: Int,
		totalPages: Int,
		height: CGFloat,
		width: CGFloat,
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: String(
				format: String(localized: "export_pdf.page"),
				arguments: ["\(currentPage)", "\(totalPages)"]
			),
			attributes: [
				.font: UIFont(
					name: "Helvetica",
					size: 10
				) as Any,
				.foregroundColor: UIColor(theme.secondaryText)
			]
		)
		
		let textBox = text.boundingRect(
			with: CGSize(width: width, height: .greatestFiniteMagnitude),
			options: .usesLineFragmentOrigin,
			context: nil
		)
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(
				x: Constants.outerMargin + width - textBox.width,
				y: height - textBox.height,
				width: textBox.width,
				height: textBox.height
			),
			height: 0
		)
	}
	
	@MainActor func createGroupedHeading(
		heading: String,
		currentY: CGFloat,
		width: CGFloat,
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: heading,
			attributes: [
				.font: UIFont(
					name: "Helvetica-Bold",
					size: 16
				) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let textHeight = text.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height + 12
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(x: Constants.outerMargin, y: currentY, width: width, height: textHeight),
			height: textHeight
		)
	}
	
	@MainActor func createTableHeading(
		heading: String,
		currentY: CGFloat,
		width: CGFloat,
	) -> PdfDrawElement {
		
		let style = NSMutableParagraphStyle()
		style.alignment = NSTextAlignment.center
		
		let text = NSAttributedString(
			string: heading,
			attributes: [
				.font: UIFont(
					name: "Helvetica-Bold",
					size: 12
				) as Any,
				.foregroundColor: UIColor(theme.primaryText),
				.paragraphStyle: style
			]
		)
		
		let textHeight = text.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height
		
		return PdfDrawElement(
			text: text,
			backgroundColor: nil,
			borderColor: theme.border,
			rect: CGRect(x: Constants.outerMargin, y: currentY, width: width, height: textHeight),
			height: textHeight + 11
		)
	}
	
	@MainActor func createSubTableHeading(
		heading: String,
		currentY: CGFloat,
		width: CGFloat,
	) -> PdfDrawElement {
		
		let text = NSAttributedString(
			string: heading,
			attributes: [
				.font: UIFont(
					name: "Helvetica-Bold",
					size: 10
				) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let textHeight = text.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height
		
		return PdfDrawElement(text: text, backgroundColor: nil, borderColor: theme.border, rect: CGRect(x: Constants.outerMargin, y: currentY, width: width, height: textHeight), height: textHeight + 11)
	}
	
	@MainActor func createSubTableRow(
		key: String,
		value: String,
		currentY: CGFloat,
		width: CGFloat
	) -> [PdfDrawElement] {
		
		let keyText = NSAttributedString(
			string: key,
			attributes: [
				.font: UIFont(
					name: "Helvetica",
					size: 10
				) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let valueText = NSAttributedString(
			string: value,
			attributes: [
				.font: UIFont(
					name: "Helvetica",
					size: 10
				) as Any,
				.foregroundColor: UIColor(theme.primaryText)
			]
		)
		
		let keyHeight = keyText.boundingRect(with: CGSize(width: (width / 2) - 12, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height
		
		let valueHeight = valueText.boundingRect(with: CGSize(width: (width / 2) - 12, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height
		
		let textHeight = max(keyHeight, valueHeight)
		
		return [
			PdfDrawElement(text: keyText, backgroundColor: theme.secondaryBackground, borderColor: theme.border, rect: CGRect(x: Constants.outerMargin, y: currentY, width: width / 2, height: textHeight), height: textHeight + 11),
			PdfDrawElement(text: valueText, backgroundColor: nil, borderColor: theme.border, rect: CGRect(x: Constants.outerMargin + (width / 2) - 1, y: currentY, width: (width / 2) + 1, height: textHeight), height: textHeight + 11)
		]
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
