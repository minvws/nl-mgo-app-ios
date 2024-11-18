/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import Zibs
import RestrictedBrowser

/// The states of a download view
enum HealthCategoryDownloadState: Equatable {
	
	case loading
	case idle(label: String)
	case downloaded(label: String, documentUrl: URL)
	case external(label: String, documentUrl: URL)
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
	
	/// show the preview when downloaded
	@Published var showPreview: Bool = false
	
	/// The repository for binaries
	private let binaryRepository: BinaryRepositoryProtocol = BinaryRepository()
	
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
			state = .idle(label: entry.label)
		}
	}
	
	deinit {
		binaryRepository.clear()
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case download
		case shareDocument(url: URL)
		case shareUrl(url: URL)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthCategoryDownloadViewModel.Action) {
		
		switch action {
			case .download: download()
			case let .shareDocument(url): shareDocument(url)
			case let .shareUrl(url): shareUrl(url)
		}
	}
	
	private func download() {
		
		guard let urlString = entry.url else {
			state = .noDocument
			return
		}
		
		guard state != .loading else { return }
		state = .loading
		
		logInfo("Tapped on", entry.url as Any)
		
		if urlString.starts(with: "https") {
			
			guard let externalUrl = URL(string: urlString) else {
				state = .noDocument
				return
			}
			openExternalUrl(externalUrl)
		
		} else if urlString.starts(with: "Binary/") {
			
			_Concurrency.Task {
				await loadBinary(urlString)
			}
		} else {
			state = .noDocument
		}
	}
	
	private func openExternalUrl(_ url: URL) {
		
		state = .external(label: entry.label, documentUrl: url)
		shareUrl(url)
	}
	
	private func shareDocument(_ url: URL) {
		
		guard let vc = UIApplication.shared.firstKeyWindow?.rootViewController else { return }
		
		let shareActivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		shareActivity.popoverPresentationController?.sourceView = vc.view
		shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
		shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
		vc.present(shareActivity, animated: true, completion: nil)
	}
	
	private func shareUrl(_ url: URL) {
		
		let browser: RestrictedBrowser = RestrictedBrowser(allowedDomains: [])
		browser.handleUnallowedDomain(url)
	}
	
	@MainActor
	func loadBinary(_ url: String) async {
		do {
			if let binary = try await Current.resourceRepository.loadBinary(healthcareOrganization, serviceId: "51", url: url) {
				logInfo("binary", binary.contentType)
				
				var name = entry.label
				switch binary.contentType {
					case "application/pdf": name += ".pdf"
					default: break
				}
				let url = try binaryRepository.store(binary, as: name)
				self.state = .downloaded(label: entry.label, documentUrl: url)
				showPreview = true
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
	
	@State private var failedToOpenPreview: Bool = false
	
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
			
			case let .idle(label: label):
				CallToActionButton(
					title: label,
					icon: Image(ImageResource.Schema.attachFile),
					style: .tertiaryWithIcon) {
						viewModel.reduce(.download)
					}
			
			case let .downloaded(label: label, documentUrl: documentUrl):
				CallToActionButton(
					title: label,
					icon: Image(ImageResource.Schema.attachFile),
					style: .tertiaryWithIcon) {
						if failedToOpenPreview {
							viewModel.reduce(.shareDocument(url: documentUrl))
						} else {
							viewModel.showPreview = true
						}
					}
					.background(DocumentPreviewController($viewModel.showPreview, failedToOpen: $failedToOpenPreview, url: documentUrl))
					.onChange(of: failedToOpenPreview) { newValue in
						if newValue {
							viewModel.reduce(.shareDocument(url: documentUrl))
						}
					}
			
			case let .external(label: label, documentUrl: documentUrl):
				CallToActionButton(
					title: label,
					icon: Image(ImageResource.Schema.attachFile),
					style: .tertiaryWithIcon) {
						viewModel.reduce(.shareUrl(url: documentUrl))
					}
			
			case .loading:
				loadingView()
			
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
