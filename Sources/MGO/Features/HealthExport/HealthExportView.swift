/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOFoundation
import MGOUI
import PDFKit

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
		
		return PdfData(
			heading: "Heading",
			subHeading: "Subheading",
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
										(key: "Key 1", value: "Value 1"),
										(key: "Key 2", value: "Value 2"),
										(key: "Key 3", value: "Value 3")
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
										(key: "Key 1", value: "Value 1"),
										(key: "Key 2", value: "Value 2"),
										(key: "Key 3", value: "Value 3")
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
										(key: "Key 1", value: "Value 1"),
										(key: "Key 2", value: "Value 2"),
										(key: "Key 3", value: "Value 3")
									]
								),
								PdfSubTable(
									heading: "Table Sub Heading #4",
									data: [
										(key: "Key 1", value: "Value 1"),
										(key: "Key 2", value: "Value 2"),
										(key: "Key 3", value: "Value 3")
									]
								)
							]
						)
					]
				)
			],
			footer: "Footer"
		)
	}
	
	private let metaData = [
		kCGPDFContextAuthor: String(localized: "common.app_name"),
		kCGPDFContextSubject: String(localized: "export_pdf.footer")
	]
	
	@MainActor private func generatePDF() {
		
		let pageWidth: CGFloat = 595.28 // A4 Paper Size
		let pageHeight: CGFloat = 841.89 // A4 Paper Size
		let margin: CGFloat = 28
		let contentWidth = pageWidth - 2 * margin
		let contentHeight = pageHeight - 2 * margin
		
		let format = UIGraphicsPDFRendererFormat()
		format.documentInfo = metaData as [String: Any]
		
		let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
		
		var currentY: CGFloat = margin
		
		let data = pdfRenderer.pdfData { context in
			
			context.beginPage()
			
			drawPdfHeading(context: context, heading: "Medicijnen", currentY: &currentY, width: contentWidth, contentHeight: contentHeight, margin: margin)
			
			currentY += 16
			
			drawGroupedHeading(context: context, heading: "Die je nu gebruikt", currentY: &currentY, width: contentWidth, contentHeight: contentHeight, margin: margin)
			
			currentY += 16
			
			for _ in 0...10 {
				
				drawTableHeading(context: context, heading: "Atorvastatine 20 mg", currentY: &currentY, width: contentWidth, contentHeight: contentHeight, margin: margin)
				
				drawSubTableRow(context: context, key: "Datum van de uitslag", value: "18 maart 2024, 18 maart 2024, 18 maart 2024, 18 maart 2024, 18 maart 2024, 18 maart 2024, 18 maart 2024, 18 maart 2024, 18 maart 2024, 18 maart 2024, 18 maart 2024, 18 maart 2024", currentY: &currentY, width: contentWidth, contentHeight: contentHeight, margin: margin)
				
				drawSubTableRow(context: context, key: "Resultaat", value: "5,4 millimol per liter", currentY: &currentY, width: contentWidth, contentHeight: contentHeight, margin: margin)
				
				drawSubTableHeading(context: context, heading: "Normale referentiewaarden", currentY: &currentY, width: contentWidth, contentHeight: contentHeight, margin: margin)
				
				drawSubTableRow(context: context, key: "Minimale waarde", value: "3,5 millimol per liter", currentY: &currentY, width: contentWidth, contentHeight: contentHeight, margin: margin)
				
				drawSubTableRow(context: context, key: "Maximale waarde", value: "5,6 millimol per liter", currentY: &currentY, width: contentWidth, contentHeight: contentHeight, margin: margin)
			
				currentY += 16
			}
			
		}
		
		if let document = PDFDocument(data: data) {
			state = .document(document)
		}
	}
	
	func drawPdfHeading(
		context: UIGraphicsPDFRendererContext,
		heading: String,
		currentY: inout CGFloat,
		width: CGFloat,
		contentHeight: CGFloat,
		margin: CGFloat
	) {
		
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
		
		let textHeight = text.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height
		
		if currentY + textHeight > contentHeight + margin {
			context.beginPage()
			currentY = margin
		}
		
		draw(
			context: context,
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(x: margin, y: currentY, width: width, height: textHeight)
		)
		currentY += textHeight
	}
	
	func drawGroupedHeading(
		context: UIGraphicsPDFRendererContext,
		heading: String,
		currentY: inout CGFloat,
		width: CGFloat,
		contentHeight: CGFloat,
		margin: CGFloat
	) {
		
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
		
		if currentY + textHeight > contentHeight + margin {
			context.beginPage()
			currentY = margin
		}
		
		draw(
			context: context,
			text: text,
			backgroundColor: nil,
			borderColor: nil,
			rect: CGRect(x: margin, y: currentY, width: width, height: textHeight)
		)
		currentY += textHeight
	}
	
	func drawTableHeading(
		context: UIGraphicsPDFRendererContext,
		heading: String,
		currentY: inout CGFloat,
		width: CGFloat,
		contentHeight: CGFloat,
		margin: CGFloat
	) {
		
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
		
		if currentY + textHeight + 12 > contentHeight + margin {
			context.beginPage()
			currentY = margin
		}
		
		draw(
			context: context,
			text: text,
			backgroundColor: nil,
			borderColor: theme.border,
			rect: CGRect(x: margin, y: currentY, width: width, height: textHeight)
		)
		currentY += textHeight + 11
	}
	
	func drawSubTableHeading(
		context: UIGraphicsPDFRendererContext,
		heading: String,
		currentY: inout CGFloat,
		width: CGFloat,
		contentHeight: CGFloat,
		margin: CGFloat
	) {
		
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
		
		if currentY + textHeight + 12 > contentHeight + margin {
			context.beginPage()
			currentY = margin
		}
		
		draw(
			context: context,
			text: text,
			backgroundColor: nil,
			borderColor: theme.border,
			rect: CGRect(x: margin, y: currentY, width: width, height: textHeight)
		)
		currentY += textHeight + 11
	}
	
	func drawSubTableRow(
		context: UIGraphicsPDFRendererContext,
		key: String,
		value: String,
		currentY: inout CGFloat,
		width: CGFloat,
		contentHeight: CGFloat,
		margin: CGFloat
	) {
		
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
		
		if currentY + textHeight + 12 > contentHeight + margin {
			context.beginPage()
			currentY = margin
		}
		
		draw(
			context: context,
			text: keyText,
			backgroundColor: theme.secondaryBackground,
			borderColor: theme.border,
			rect: CGRect(x: margin, y: currentY, width: width / 2, height: textHeight)
		)
		
		draw(
			context: context,
			text: valueText,
			backgroundColor: nil,
			borderColor: theme.border,
			rect: CGRect(x: margin + width / 2, y: currentY, width: width / 2, height: textHeight)
		)
		
		currentY += textHeight + 11
	}
	
	func drawFooter() {
		
	}
	
	func draw(
		context: UIGraphicsPDFRendererContext,
		text: NSAttributedString,
		backgroundColor: Color?,
		borderColor: Color?,
		rect: CGRect
	) {
		
		var inset: CGFloat = 0
		
		if let borderColor {
			inset = 6
			context.cgContext.setLineWidth(1)
			context.cgContext.setStrokeColor(UIColor(borderColor).cgColor)
			context.stroke(CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height + 12))
		}
			
		if let backgroundColor {
			inset = 6
			context.cgContext.setFillColor(UIColor(backgroundColor).cgColor)
			context.fill(CGRect(x: rect.origin.x + 1, y: rect.origin.y + 1, width: rect.width - 2, height: rect.height + 10))
		}
		
		text.draw(in: CGRect(x: rect.origin.x + inset, y: rect.origin.y + inset, width: rect.width - 2 * inset, height: rect.height))
	}
	
	func savePDF(data: Data, fileName: String) -> URL? {
		let fileManager = FileManager.default
		guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
			return nil
		}
		let fileURL = documentDirectory.appendingPathComponent("\(fileName).pdf")
		
		do {
			try data.write(to: fileURL)
			return fileURL
		} catch {
			print("Error saving PDF: \(error.localizedDescription)")
			return nil
		}
	}
}

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
