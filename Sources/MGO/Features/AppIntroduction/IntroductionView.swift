/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

class IntroductionViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case nextButttonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)?) {
		self.coordinator = coordinator

	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: IntroductionViewModel.Action) {
		switch action {
			case .nextButttonPressed:
				coordinator?.handle(Coordination.Action.nextButtonPressedOnIntroduction)
		}
	}
}

struct IntroductionView: View {
	
	/// The view model
	@StateObject var viewModel: IntroductionViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Boolean to determine if the header image should be shown (hidden in landscape)
	@State var showImage = true
	
	/// helper to calculate the size of the view
	@State private var contentSize: CGSize = .zero
	
	/// The size classes
	@Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
	
	/// Magic numbers
	private struct ViewTraits {
		enum Image {
			static let width: CGFloat = 0.5
			static let bottom: CGFloat = 24
		}
		enum Title {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
		}
		enum Text {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
			static let spacing: CGFloat = 8
		}
		enum Button {
			static let padding: CGFloat = 16
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum Banner {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16)
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(alignment: .center, spacing: 0) {
				
				if showImage {
					// Image, 50% width
					VStack(alignment: .center) {
						Spacer()
						
						Image(ImageResource.Woman.womanWithPhone)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.padding(.bottom, ViewTraits.Image.bottom)
					}
					.frame(maxWidth: contentSize.width * ViewTraits.Image.width)
				}
				
				VStack(alignment: .leading) {
					
					Text("introduction.heading")
						.rijksoverheidStyle(font: .bold, style: .title)
						.padding(ViewTraits.Title.insets)
						.accessibilityAddTraits(.isHeader)
						.fixedSize(horizontal: false, vertical: true)
						.accessibilityIdentifier("introduction.heading")
					
					SplittedText(key: "introduction.subheading", spacing: ViewTraits.Text.spacing)
						.rijksoverheidStyle(font: .regular, style: .body)
						.padding(ViewTraits.Text.insets)
						.fixedSize(horizontal: false, vertical: true)
						.accessibilityIdentifier("introduction.subheading")
				}
				
				Spacer()
			}
			.padding(.top, ViewTraits.Navigation.padding)
			.readSize($contentSize)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.foregroundStyle(theme.contentPrimary)
			.onRotate { newOrientation in
				
				// Always show on iPad
				guard UIDevice.current.userInterfaceIdiom != .pad else { return }
				
				// The device orientation can be isFlat (faceUp or faceDown). Skip that
				guard !newOrientation.isFlat else { return }
				
				// Hide the image in landscape (on a phone)
				showImage = !newOrientation.isLandscape
			}
			.onAppear {
				showImage = verticalSizeClass != SwiftUI.UserInterfaceSizeClass.compact || UIDevice.current.userInterfaceIdiom == .pad
			}
		} bottomView: {
			
			CallToActionButton("common.next") {
				viewModel.reduce(.nextButttonPressed)
			}
			.accessibilityIdentifier("common.next")
			.padding(ViewTraits.Button.padding)
		}
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden()
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		IntroductionView(viewModel: IntroductionViewModel(coordinator: nil))
	}
}
