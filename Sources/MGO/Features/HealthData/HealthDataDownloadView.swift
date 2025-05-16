/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import RestrictedBrowser

/// The states of a download view
enum HealthDataDownloadState: Equatable {
	
	case loading(label: String)
	case idle(label: String)
	case downloaded(label: String, documentUrl: URL)
	case external(label: String, documentUrl: URL)
	case noDocument
	case error
}

class HealthDataDownloadViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: HealthDataDownloadState
	
	/// The healthcare organization this download came from
	private var healthcareOrganization: MgoOrganization
	
	/// The download link to display
	private var downloadLink: DownloadLink?
	
	/// The download binary to display
	private var downloadBinary: DownloadBinary?
	
	/// Helper to open urls
	private var urlOpener: URLOpenerProtocol?
	
	/// show the preview when downloaded
	@Published var showPreview: Bool = false
	
	/// The repository for binaries
	private var binaryRepository: BinaryRepositoryProtocol?
	
	/// Create a Download View for a Download Binary
	/// - Parameters:
	///   - healthcareOrganization: the healthcare organization
	///   - downloadBinary: the UI Download Binary
	///   - binaryRepository: the repository for binaries
	init(
		healthcareOrganization: MgoOrganization,
		downloadBinary: DownloadBinary,
		binaryRepository: BinaryRepositoryProtocol = BinaryRepository()) {
		
		self.healthcareOrganization = healthcareOrganization
		self.downloadBinary = downloadBinary
		self.binaryRepository = binaryRepository
		state = .idle(label: downloadBinary.label)
	}
	
	/// Create a Download View for a Download Link
	/// - Parameters:
	///   - healthcareOrganization: the healthcare organization
	///   - downloadLink: the download Link to display
	///   - urlOpener: the helper to open urls.
	///   - binaryRepository: the repository for binaries
	init(
		healthcareOrganization: MgoOrganization,
		downloadLink: DownloadLink,
		urlOpener: URLOpenerProtocol = UIApplication.shared) {
		
		self.healthcareOrganization = healthcareOrganization
		self.downloadLink = downloadLink
		self.urlOpener = urlOpener
		
		if downloadLink.url == nil {
			state = .noDocument
		} else {
			state = .idle(label: downloadLink.label)
		}
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case download
		case shareDocument(url: URL)
		case shareUrl(url: URL)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthDataDownloadViewModel.Action) {
		
		switch action {
			case .download: download()
			case let .shareDocument(url): shareDocument(url)
			case let .shareUrl(url): urlOpener?.openUrlIfPossible(url)
		}
	}
	
	/// Handle the click on the download button
	private func download() {
		
		if downloadLink != nil {
			doDownloadLink()
		} else if downloadBinary != nil {
			doDownloadBinary()
		}
	}
	
	/// The user tapped the download button for a download binary type
	private func doDownloadBinary() {

		// Only Binaries
		guard let downloadBinary else { return }
	
		logInfo("Tapped on", downloadBinary.reference as Any)

		// Download once
		guard state != .loading(label: downloadBinary.label) else { return }
		
		// We must have a reference link
		guard let reference = downloadBinary.reference else {
			state = .noDocument
			return
		}
		
		state = .loading(label: downloadBinary.label)
		
		_Concurrency.Task {
			await loadBinary(reference, label: downloadBinary.label)
		}
	}
	
	/// The user tapped the download button for a download link type
	private func doDownloadLink() {
		
		// Only Links
		guard let downloadLink else { return }
		
		guard let urlString = downloadLink.url else {
			state = .noDocument
			return
		}
		
		guard state != .loading(label: downloadLink.label) else { return }
		state = .loading(label: downloadLink.label)
		
		logInfo("Tapped on", downloadLink.url as Any)
		
		if urlString.starts(with: "https") {
			
			guard let externalUrl = Foundation.URL(string: urlString) else {
				state = .noDocument
				return
			}
			state = .external(label: downloadLink.label, documentUrl: externalUrl)
			urlOpener?.openUrlIfPossible(externalUrl)
		} else {
			state = .noDocument
		}
	}
	
	private func shareDocument(_ url: URL) {
		
		guard let vc = UIApplication.shared.firstKeyWindow?.rootViewController else { return }
		
		let shareActivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		shareActivity.popoverPresentationController?.sourceView = vc.view
		shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
		shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
		vc.present(shareActivity, animated: true, completion: nil)
	}
	
	@MainActor
	func loadBinary(_ externalUrl: String, label: String) async {
		
		guard let binaryRepository else {
			state = .error
			return
		}
		
		do {
			if let binary = try await Current.resourceRepository.loadBinary(
				healthcareOrganization,
				serviceId: DVP.Documents.serviceID,
				url: externalUrl
			) {
				logInfo("binary", binary.contentType)
				
				var name = label
				if binary.contentType == "application/pdf" {
					name += ".pdf"
				}
				let storeUrl = try binaryRepository.store(binary, as: name)
				self.state = .downloaded(label: label, documentUrl: storeUrl)
				showPreview = true
			} else {
				state = .error
			}
		} catch {
			state = .error
		}
	}
}

struct HealthDataDownloadView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthDataDownloadViewModel
	
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
					style: .withIcon) {
						viewModel.reduce(.download)
					}
			
			case let .downloaded(label: label, documentUrl: documentUrl):
				CallToActionButton(
					title: label,
					icon: Image(ImageResource.Schema.attachFile),
					style: .withIcon) {
						if failedToOpenPreview {
							viewModel.reduce(.shareDocument(url: documentUrl))
						} else {
							viewModel.showPreview = true
						}
					}
					.sheet(isPresented: $viewModel.showPreview) {
						DocumentPreviewController($viewModel.showPreview, failedToOpen: $failedToOpenPreview, url: documentUrl)
							.background(theme.backgroundPrimary)
							.interactiveDismissDisabled(true)
					}
					.onChange(of: failedToOpenPreview) { newValue in
						if newValue {
							viewModel.reduce(.shareDocument(url: documentUrl))
						}
					}
			
			case let .external(label: label, documentUrl: documentUrl):
				CallToActionButton(
					title: label,
					icon: Image(ImageResource.Schema.attachFile),
					style: .withIcon) {
						viewModel.reduce(.shareUrl(url: documentUrl))
					}
			
			case let .loading(label: label):
				CallToActionButton(
					title: label,
					style: .withSpinner) {
						// No action while loading
					}
			
			case .noDocument:
				feedbackView(
					"hc_documents.no_document",
					iconColor: theme.sentimentInformation
				)
			
			case .error:
				feedbackView(
					"hc_documents.error",
					iconColor: theme.sentimentCritical,
					actionTitle: "common.try_again") {
						viewModel.reduce(.download)
					}
		}
	}
	
	/// Create a feedback view
	/// - Parameters:
	///   - text: the text to display
	///   - iconColor: the color of the icon
	///   - actionTitle: the optional title for an action
	///   - action: the action to perform when the user taps on the action title
	/// - Returns: feedback view
	@ViewBuilder private func feedbackView(
		_ text: LocalizedStringKey,
		iconColor: Color,
		actionTitle: LocalizedStringKey? = nil,
		action: (() -> Void)? = nil) -> some View {
		
		VStack(alignment: .center, spacing: ViewTraits.Feedback.spacing) {
			Image(ImageResource.Schema.error)
				.foregroundStyle(iconColor)
			
			Text(text)
				.multilineTextAlignment(.center)
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
			
			if let actionTitle {
				Button {
					action?()
				} label: {
					Text(actionTitle)
				}
				.buttonStyle(LinkButtonStyle(.center))
				.accessibilityIdentifier("feedbackAction")
			}
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.horizontal, ViewTraits.Feedback.horizontal)
		.padding(.vertical, ViewTraits.Feedback.vertical)
		.accessibilityElement(children: .combine)
	}
}
