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
		}
	}
	
	@MainActor private func generatePDF() {
		
		if #available(iOS 16.0, *) {
			let document = PDFDocument()
			
			var renderer = ImageRenderer(content: ExportPageView().frame(width: 595.28, height: 841.89))
			if let image = renderer.uiImage,
				let page = PDFPage(image: image) {
				
				document.insert(page, at: 0)
			}
			
			renderer = ImageRenderer(content: ExportPageView().frame(width: 595.28, height: 841.89))
			if let image = renderer.uiImage,
				let page = PDFPage(image: image) {
				
				document.insert(page, at: 1)
			}
			state = .document(document)
			
		} else {
			// Fallback on earlier versions
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
					PDFKitView(pDFDocument)
			}
		}
		.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
}
