/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import RestrictedBrowser

/// The states of a download view
enum HealthDataDownloadState: Equatable, Sendable {
	
	case loading(label: String)
	case idle(label: String)
	case downloaded(label: String, documentUrl: URL)
	case external(label: String, documentUrl: URL)
	case noDocument
	case error
}

@MainActor class HealthDataDownloadViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: HealthDataDownloadState
	
	/// The healthcare organization this download came from
	private var healthcareOrganization: OrganizationSearch.Organization
	
	/// The download link to display
	private var downloadLink: DownloadLink?
	
	/// The download binary to display
	private var downloadBinary: DownloadBinary?
	
	/// Helper to open urls
	private var urlOpener: URLOpenerProtocol?
	
	/// show the preview when downloaded
	@Published var showPreview: Bool = false
	
	/// The repository for binaries
	private var fileStorage: FileStorageProtocol?
	
	/// Dependency Injectable Resource Repository
	@Injected(\.resourceRepository) private var resourceRepository
	
	/// Create a Download View for a Download Binary
	/// - Parameters:
	///   - healthcareOrganization: the healthcare organization
	///   - downloadBinary: the UI Download Binary
	///   - storage: the file storage
	init(
		healthcareOrganization: OrganizationSearch.Organization,
		downloadBinary: DownloadBinary,
		storage: FileStorageProtocol = FileStorage(subDirectory: HealthDirectory.binary)
	) {
		
		self.healthcareOrganization = healthcareOrganization
		self.downloadBinary = downloadBinary
		self.fileStorage = storage
		state = .idle(label: downloadBinary.label)
	}
	
	/// Create a Download View for a Download Link
	/// - Parameters:
	///   - healthcareOrganization: the healthcare organization
	///   - downloadLink: the download Link to display
	///   - urlOpener: the helper to open urls.
	///   - binaryRepository: the repository for binaries
	@MainActor init(
		healthcareOrganization: OrganizationSearch.Organization,
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
	@MainActor func reduce(_ action: HealthDataDownloadViewModel.Action) {
		
		switch action {
			case .download: download()
			case let .shareDocument(url): shareDocument(url)
			case let .shareUrl(url): urlOpener?.openUrlIfPossible(url)
		}
	}
	
	/// Handle the click on the download button
	@MainActor private func download() {
		
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
		
		_Concurrency.Task(priority: .userInitiated) {
			await loadBinary(reference, label: downloadBinary.label)
		}
	}
	
	/// The user tapped the download button for a download link type
	@MainActor private func doDownloadLink() {
		
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
	
	@MainActor
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
		
		do {
			if let documentService = DataServices().services.first(where: { $0.name == "Documents PDF/A" }),
			   let binary = try await resourceRepository.loadBinary(
				healthcareOrganization,
				serviceId: documentService.id,
				path: externalUrl
			) {
				logInfo("binary", binary.contentType)
				
				var name = label
				if binary.contentType == "application/pdf" {
					name += ".pdf"
				}
				guard let storeUrl = fileStorage?.fileUrl(name),
					  let data = Data(base64Encoded: binary.content) else {
					state = .error
					return
				}
				try fileStorage?.store(data, as: name)
				
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
	@Environment(\.mgoTheme) var theme
	
	@State private var failedToOpenPreview: Bool = false
	
	@Environment(\.colorScheme) var colorScheme
	
	/// Magic Numbers
	private struct ViewTraits {
		
		enum Feedback {
			static let horizontal: CGFloat = 16
			static let vertical: CGFloat = 24
			static let spacing: CGFloat = 8
		}
		enum Preview {
			static let lightBackgroundColor: Color = Color(hex: "FCFCFC")
			static let dardBackgroundColor: Color = Color(hex: "E7E7E7")
		}
	}
	
	var body: some View {
		
		switch viewModel.state {
			
			case let .idle(label: label):
				CallToActionButton(
					title: label,
					icon: Image(systemName: "paperclip"),
					style: .withIcon) {
						viewModel.reduce(.download)
					}
			
			case let .downloaded(label: label, documentUrl: documentUrl):
				CallToActionButton(
					title: label,
					icon: Image(systemName: "paperclip"),
					style: .withIcon) {
						if failedToOpenPreview {
							viewModel.reduce(.shareDocument(url: documentUrl))
						} else {
							viewModel.showPreview = true
						}
					}
					.inspectableSheet(isPresented: $viewModel.showPreview, content: {
						DocumentPreviewController($viewModel.showPreview, failedToOpen: $failedToOpenPreview, url: documentUrl)
							.background(
								colorScheme == .light ? ViewTraits.Preview.lightBackgroundColor : ViewTraits.Preview
									.dardBackgroundColor)
							.interactiveDismissDisabled(true)
					})
					.onChange(of: failedToOpenPreview) { newValue in
						if newValue {
							viewModel.reduce(.shareDocument(url: documentUrl))
						}
					}
			
			case let .external(label: label, documentUrl: documentUrl):
				CallToActionButton(
					title: label,
					icon: Image(systemName: "paperclip"),
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
					iconColor: theme.states.informative
				)
			
			case .error:
				feedbackView(
					"hc_documents.error",
					iconColor: theme.states.critical,
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
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.primary)
			
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
