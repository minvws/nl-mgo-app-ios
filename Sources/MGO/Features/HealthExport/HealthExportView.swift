/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import PdfExport
import FileStorage

@MainActor
class HealthExportViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The PDF data source
	private var dataSource: PdfData
	
	/// The storage provider
	private let storage: FileStorageProtocol
	
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
	@Published var title: String
	
	/// The path to the generated pdf
	@Published var pdfUrl: URL?
	
	/// Should we render for iPad?
	@Published var forIpad: Bool = false
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case closeSheet
		case onAppear
		case safePdf
	}
	
	/// Create a Health category view model
	/// - Parameter coordinator: the app coordinator
	/// - Parameter healthData: the health data to export
	/// - Parameter storage: the file storage system
	/// - Parameter forIpad: should we render for iPad
	init(
		coordinator: (any Coordinator)? = nil,
		healthData: PdfData,
		storage: FileStorageProtocol = FileStorage(subDirectory: HealthDirectory.export),
		forIpad: Bool = UIDevice.current.userInterfaceIdiom == .pad
	) {
		self.coordinator = coordinator
		self.state = .loading
		self.title = healthData.heading
		self.storage = storage
		self.dataSource = healthData
		self.forIpad = forIpad
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthExportViewModel.Action) async {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
				
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
				
			case .onAppear:
				guard case .loading = state else { return }
				await generatePDF()

				if case let .document(pDFDocument) = state, !isIOS15,
				   let data = pDFDocument.dataRepresentation(),
				   let url = savePDF(data: data) {
					logDebug("Saving PDF onAppear", url as Any)
					pdfUrl = url
				}
				
			case .safePdf:
				if case let .document(pDFDocument) = state,
				   let data = pDFDocument.dataRepresentation(),
				   let url = savePDF(data: data) {
					logDebug("Saving PDF on safePdf", url as Any)
					shareDocument(url)
				}
		}
	}
	
	internal var presentSharing: Bool = false
	
	/// Create a share window
	/// - Parameter url: the url of the document to share
	private func shareDocument(_ url: URL) {
		
		presentSharing = true
		guard let vc = UIApplication.shared.firstKeyWindow?.rootViewController else { return }
		
		let shareActivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		shareActivity.popoverPresentationController?.sourceView = vc.view
		shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
		shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
		vc.present(shareActivity, animated: true, completion: nil)
	}
	
	/// Generate the PDF
	internal func generatePDF() async {
		if let document = await HealthExportPdfGenerator(
			dataSource: dataSource
		).generatePDF() {
			state = .document(document)
		}
	}
	
	/// Save the document
	/// - Parameters:
	///   - data: the pdf in binary
	///   - fileName: the name of the file
	/// - Returns: url to the saved file.
	func savePDF(data: Data) -> URL? {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d_MMM_yyyy"
		dateFormatter.locale = Locale(identifier: "nl")
		dateFormatter.timeZone = TimeZone(identifier: "Europe/Amsterdam")
		let dateString = dateFormatter.string(from: Container.shared.now()())
		
		let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
		let sanitized = dataSource.heading.lowercased()
			.components(separatedBy: allowed.inverted)
			.filter { !$0.isEmpty }
			.joined(separator: "_")
		let fileName = "mgo_\(sanitized)_\(dateString)"
		
		do {
			try storage.store(data, as: "\(fileName).pdf")
			return storage.fileUrl("\(fileName).pdf")
		} catch {
			logError(error.localizedDescription)
			return nil
		}
	}
}

struct HealthExportView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthExportViewModel
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
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
					loadingView
					
				case .document(let pdfDocument):
					pdfContent(pdfDocument: pdfDocument)
			}
		}
		.interactiveDismissDisabled(true) // Disable dragging by the user for this sheet
		.frame(maxWidth: .infinity)
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.task {
			await viewModel.reduce(.onAppear)
		}
		.navigationTitle(viewModel.title)
		.navigationBarBackButtonHidden()
		.when(isPresentedAsSheet, transform: { view in
			view
				.toolbar(content: close)
		})
		.when(!isPresentedAsSheet, transform: { view in
			// Happens on iOS 15
			view
				.toolbar(content: shareTopBarTrailing)
				.navigationBarItems(leading: BackButton { backButtonTapped() })
				.navigationBarTitleDisplayMode(.inline)
		})
	}
	
	/// Document rendering
	@ViewBuilder private func pdfContent(pdfDocument: PDFDocument) -> some View {
		
		PDFKitView(pdfDocument)
			.padding(.horizontal, ViewTraits.General.padding)
			.when(osVersionChecker.available(version: .iOS(.v26))) { view in
				ZStack {
					view
						.ignoresSafeArea(edges: .bottom)
						.toolbar(content: shareBottomBarTrailing)
				}
			}
			.when(!osVersionChecker.available(version: .iOS(.v26)) && !viewModel.forIpad) { view in
				Group {
					view
					shareButton
				}
			}
			.when(!osVersionChecker.available(version: .iOS(.v26)) && viewModel.forIpad) { view in
				view
					.toolbar(content: shareTopBarLeading)
			}
	}
	
	/// The loading state for the view
	@ViewBuilder private var loadingView: some View {
		
		Spacer()
		
		ProgressView("pdf_viewer.loading")
			.foregroundStyle(theme.labels.secondary)
			.typography(.bodyMedium)
		
		Spacer()
	}
	
	/// The share button
	@ViewBuilder private var shareButton: some View {
		
		HStack {
			shareLink(viewModel.pdfUrl)
			Spacer()
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.padding(.top, ViewTraits.General.padding)
		.background(theme.backgrounds.secondary)
	}
	
	/// Content for the close button toolbar
	/// - Returns: the close button in a toolbar
	@ToolbarContentBuilder private func close() -> some ToolbarContent {
		ToolbarItemGroup(
			placement: .topBarTrailing,
			content: {
				
				let closeKey: LocalizedStringKey = "export_pdf.close"
				
				if osVersionChecker.available(version: .iOS(.v26)) {
					if #available(iOS 26.0, *) {
						Button(role: .close) { closeButtonTapped() }
						.accessibilityLabel(closeKey)
						.accessibilityIdentifier("export_pdf.close")
						.tint(theme.labels.primary)
					}
				} else {
					
					Button(closeKey) { closeButtonTapped() }
					.buttonStyle(ToolbarButtonStyle())
					.accessibilityIdentifier("export_pdf.close")
				}
			}
		)
	}
	
	/// Content for the share button toolbar
	/// - Returns: the share button in a toolbar
	@ToolbarContentBuilder private func shareTopBarTrailing() -> some ToolbarContent {
		ToolbarItemGroup(
			placement: .topBarTrailing,
			content: {
				Button { shareButtonTapped() } label: {
					Image(systemName: "square.and.arrow.up")
				}
				.accessibilityLabel("export_pdf.share")
				.accessibilityIdentifier("export_pdf.share")
				
			}
		)
	}
	
	/// Content for the share button toolbar
	/// - Returns: the share button in a toolbar
	@ToolbarContentBuilder private func shareTopBarLeading() -> some ToolbarContent {
		ToolbarItemGroup(
			placement: .topBarLeading,
			content: {
				shareLink(viewModel.pdfUrl)
			}
		)
	}
	
	/// Content for the share button toolbar
	/// - Returns: the share button in a toolbar
	@ToolbarContentBuilder private func shareBottomBarTrailing() -> some ToolbarContent {
		ToolbarItemGroup(
			placement: .bottomBar,
			content: {
				Spacer()
				shareLink(viewModel.pdfUrl)
					.tint(theme.labels.primary)
			}
		)
	}
	
	/// The share link for the pdf (iOS 16 and up)
	/// - Parameter url: the url to the pdf
	/// - Returns: share link for the pdf
	@ViewBuilder func shareLink(_ url: URL?) -> some View {
		
		if #available(iOS 16.0, *), let url {
			ShareLink(item: url) {
				Image(systemName: "square.and.arrow.up")
					.resizable()
					.scaledToFit()
					.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size)
			}
			.accessibilityLabel("export_pdf.share")
			.accessibilityIdentifier("export_pdf.share")
		}
	}

	// MARK: - Actions

	private func backButtonTapped() {
		Task { await viewModel.reduce(.backButtonPressed) }
	}

	private func closeButtonTapped() {
		Task { await viewModel.reduce(.closeSheet) }
	}

	private func shareButtonTapped() {
		Task { await viewModel.reduce(.safePdf) }
	}
}
