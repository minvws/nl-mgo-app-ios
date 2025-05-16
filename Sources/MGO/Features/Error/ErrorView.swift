/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

protocol ErrorViewModelProtocol: ObservableObject {
	
	associatedtype Body: View
	
	/// The title of the error view
	var title: LocalizedStringKey { get set }
	
	/// The main image of the error view
	var image: ImageResource { get set }
	
	/// The view for the body
	/// - Returns: View
	func viewForBody() -> Body
	
	/// The body of the error view
	var body: LocalizedStringKey { get set }
	
	/// The title of the action button
	var button: LocalizedStringKey { get set }
	
	/// The action when the user pressed the CTA
	var action: () -> Void { get set }
}

class ErrorViewModel: ErrorViewModelProtocol {
	
	init(
		title: LocalizedStringKey = "common.error_heading",
		image: ImageResource = ImageResource.Woman.womanOnCouchExclamation,
		body: LocalizedStringKey = "common.error_subheading",
		button: LocalizedStringKey = "common.try_again",
		action: @escaping () -> Void) {
			self.title = title
			self.image = image
			self.body = body
			self.button = button
			self.action = action
		}
	
	@Published var title: LocalizedStringKey
	
	@Published var image: ImageResource
	
	var body: LocalizedStringKey
	
	@Published var button: LocalizedStringKey
	
	@Published var action: () -> Void
	
	@ViewBuilder func viewForBody() -> some View {
		Text(body)
	}
}

private struct ErrorViewViewTraits {
	enum General {
		static let spacing: CGFloat = 24
		static let padding: CGFloat = 16
	}
	enum Image {
		static let insets = EdgeInsets( top: 0, leading: 50, bottom: 0, trailing: 50)
		static let height: CGFloat = 161
	}
	enum Navigation {
		static let padding: CGFloat = 8
	}
}

struct ErrorView<ViewModel>: View where ViewModel: ErrorViewModelProtocol {
	
	/// The view model
	@StateObject private var viewModel: ViewModel
	
	/// Initializer
	/// - Parameter viewModel: the view model
	init(viewModel: @autoclosure @escaping () -> ViewModel) {
		
		self._viewModel = StateObject(wrappedValue: viewModel())
	}
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Progress for the spinner
	@State private var progress: Double = 0
	
	/// State vars for the width of the image
	@State private var contentSize: CGSize = .zero
	@State private var padding: CGFloat = 0
	
	/// The horizontal size classes (to determine the layout)
	@Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
	
	/// Should we adjust the layout for iPad (i.e., are we running on an iPad)?
	private var shouldLayoutForiPad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			VStack(spacing: ErrorViewViewTraits.General.spacing) {
				
				Text(viewModel.title)
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Image(viewModel.image)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.accessibilityHidden(true)
					.padding(ErrorViewViewTraits.Image.insets)
					.readSize($contentSize)
					.onChange(of: contentSize) { size in
						if shouldLayoutForiPad && horizontalSizeClass == .regular {
							padding = 0.25 * size.width
						} else {
							padding = 0
						}
					}
					.padding(.horizontal, padding)
				
				viewModel.viewForBody()
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
				
				Spacer()
			}
			.padding(.horizontal, ErrorViewViewTraits.General.padding)
		} bottomView: {
			CallToActionButton(viewModel.button) {
				viewModel.action()
			}
			.accessibilityIdentifier("action_button")
			.padding(ErrorViewViewTraits.General.padding)
		}
		.padding(.top, ErrorViewViewTraits.Navigation.padding)
		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
}

#Preview {
	NavigationView {
		ErrorView(viewModel:
			ErrorViewModel(action:
				{ /* No Action for preview */ }
			)
		)
	}
}
