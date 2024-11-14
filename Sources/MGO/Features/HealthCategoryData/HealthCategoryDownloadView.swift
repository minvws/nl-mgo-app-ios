/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import Zibs

/// The states of a download view
enum HealthCategoryDownloadState: Equatable {
	
	case loading
	case idle(label: String, documentUrl: URL?)
	case noDocument
	case error
}

class HealthCategoryDownloadViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: HealthCategoryDownloadState
	
	/// The healthcare organization this download came from
	private var healthcareOrganization: MgoOrganization
	
	/// Part of the UISchema we need to display for this download
	private var entry: UIEntry
	
	var documentUrl: URL?
	
	@Published var showPreview: Bool = false
	
//	@Published var canOpenPreview: Bool = false //{
////		didSet {
////			print("We can open the preview \(canOpenPreview)")
////		}
////	}
	
	private let fileManager = FileManager.default
	
	/// Create a Download View
	/// - Parameters:
	///   - healthcareOrganization: the healthcare organization
	///   - entry: the UI Entry with download link
	init(healthcareOrganization: MgoOrganization, entry: UIEntry) {
		
		self.healthcareOrganization = healthcareOrganization
		self.entry = entry
		
		if entry.url == nil {
			state = .noDocument
		} else {
			do {
				var fileName = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).path
				fileName.append("/\(entry.label).zzz")
				self.state = .idle(label: entry.label, documentUrl: URL(fileURLWithPath: fileName))
				self.documentUrl = URL(fileURLWithPath: fileName)
			} catch {
				state = .noDocument
			}
		}
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case download
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthCategoryDownloadViewModel.Action) {
		
		guard let url = entry.url else {
			state = .noDocument
			return
		}
		
		if action == .download {
			
			guard state != .loading else { return }
			state = .loading
			
			logInfo("Tapped on", entry.url as Any)
			_Concurrency.Task {
				await loadBinary(url)
			}
		}
	}
	
	@MainActor
	func loadBinary(_ url: String) async {
		do {
			if let binary = try await Current.resourceRepository.loadBinary(healthcareOrganization, serviceId: "51", url: url) {
				logInfo("binary", binary.contentType)
				self.state = .idle(label: entry.label, documentUrl: documentUrl)
				
				if let filePath = documentUrl?.path, let content = Data(base64Encoded: binary.content) {
					fileManager.createFile(atPath: filePath, contents: content)
					showPreview = true
					
////					{
//								guard let vc = UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).first?.windows.first?.rootViewController else{
//									return
//								}
//					let shareActivity = UIActivityViewController(activityItems: [documentUrl!], applicationActivities: nil)
//								shareActivity.popoverPresentationController?.sourceView = vc.view
//								shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
//								shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
//								vc.present(shareActivity, animated: true, completion: nil)
////							}
					
				}
			}
		} catch {
			state = .error
		}
	}
}

struct HealthCategoryDownloadView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthCategoryDownloadViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	@State private var didOpen: Bool = true
	
	/// Magic Numbers
	private struct ViewTraits {
		
		enum Feedback {
			static let horizontal: CGFloat = 16
			static let vertical: CGFloat = 24
			static let spacing: CGFloat = 8
		}
	}
	
	var body: some View {
		
		switch viewModel.state {
			
			case let .idle(label: label, documentUrl: documentUrl):
				CallToActionButton(
					title: label,
					icon: Image(ImageResource.Schema.attachFile),
					style: .tertiaryWithIcon) {
						viewModel.reduce(.download)
					}
					.when(documentUrl != nil) { view in
						view
							.background(DocumentPreviewController($viewModel.showPreview, didOpen: $didOpen, url: documentUrl!))
					}
			
			case .loading:
				
				loadingView()
			
//			case .loading, .idle:
////			if let url = viewModel.documentUrl {
//				CallToActionButton(
//					title: viewModel.label,
//					icon: Image(ImageResource.Schema.attachFile),
//					style: viewModel.state == .loading ? .primaryWithSpinner : .tertiaryWithIcon) {
//						viewModel.reduce(.download)
//					}
////					.background(DocumentPreview($viewModel.showPreview, url: url))
//////					.sheet(isPresented: $viewModel.showPreview, onDismiss: {
//////						print("Dismiss")
//////					}, content: {
//////						ActivityViewController(activityItems: [url])
//////					})
////				
////			} else {
////				EmptyView()
////			}
			
			case .noDocument:
				feedbackView(
					"hc_documents.no_document",
					iconColor: theme.notificationInformation
				)
			
			case .error:
				feedbackView(
					"hc_documents.error",
					iconColor: theme.notificationError
				)
		}
	}
	
	/// View for the loading state
	/// - Returns: loading state view
	@ViewBuilder private func loadingView() -> some View {
		
		HStack(spacing: 8) {
			Spacer()
			ProgressView()
				.progressViewStyle(.circular)
			Text("common.loading_data")
			Spacer()
		}
		.rijksoverheidStyle(font: .regular, style: .body)
		.foregroundStyle(theme.contentPrimary)
		.tint(theme.contentPrimary)
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(16)
		.accessibilityElement(children: .combine)
	}
	
	/// Create a feedback view
	/// - Parameters:
	///   - text: the text to display
	///   - iconColor: the color of the icon
	/// - Returns: feedback view
	@ViewBuilder private func feedbackView(_ text: LocalizedStringKey, iconColor: Color) -> some View {
		
		VStack(alignment: .center, spacing: ViewTraits.Feedback.spacing) {
			Image(ImageResource.Schema.error)
				.foregroundStyle(iconColor)
			
			Text(text)
				.multilineTextAlignment(.center)
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.horizontal, ViewTraits.Feedback.horizontal)
		.padding(.vertical, ViewTraits.Feedback.vertical)
		.accessibilityElement(children: .combine)
	}
}
