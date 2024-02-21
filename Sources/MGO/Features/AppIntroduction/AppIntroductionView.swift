/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

class AppIntroductionViewModel: ObservableObject {
	
	/// The app coordintator for routing
	weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case nextButttonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any AppCoordinatorProtocol)?) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AppIntroductionViewModel.Action) {
		if action == .nextButttonPressed {
			coordinator?.handle(.nextButtonPressedOnAppIntroduction)
		}
	}
}

struct AppIntroductionView: View {
	
	/// The view model
	@StateObject var viewModel: AppIntroductionViewModel
	
	/// Boolean to determine if the header image shoudl be shown (hidden in landscape)
	@State var showImage = true
	
	@Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
	
	/// Magic numbers
	private struct ViewTraits {
		enum Image {
			static let top: CGFloat = 50
			static let insets = EdgeInsets( top: 50, leading: 30, bottom: 25, trailing: 30)
		}
		enum Title {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 16, trailing: 16)
		}
		enum Text {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 0, trailing: 16)
			static let spacing: CGFloat = 8
		}
		enum Button {
			static let padding: CGFloat = 16
		}
	}
	
	var body: some View {
		ZStack {
			
			Color.Styleguide.background
				.ignoresSafeArea()
			
			ScrollViewWithFixedBottom(content: {
				
				VStack(alignment: .leading) {
					if showImage {
						HStack {
							Spacer()
							Image(.onboarding)
								.resizable()
								.scaledToFit()
							Spacer()
						}
						.accessibilityHidden(true)
						.padding(ViewTraits.Image.insets)
					}
					
					Text("onboarding_title")
						.rijksoverheidStyle(font: .bold, style: .title2)
						.padding(ViewTraits.Title.insets)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.padding(.top, showImage ? 0 : ViewTraits.Image.top)
						.accessibilityAddTraits(.isHeader)
					
					SplittedText(key: "onboarding_body", spacing: ViewTraits.Text.spacing)
						.rijksoverheidStyle(font: .regular, style: .body)
						.padding(ViewTraits.Text.insets)
						.frame(maxWidth: .infinity, alignment: .topLeading)
					
					Spacer()
				}
				.foregroundColor(Color.Styleguide.black)
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
			}, bottomView: {
				
				Button(
					action: {
						viewModel.reduce(.nextButttonPressed)
					},
					label: {
						SkyBlueButton("onboarding_action")
					}
				)
				.hapticFeedback(.medium)
				.padding(ViewTraits.Button.padding)
			}
			)
		}
		.navigationBarBackButtonHidden()
	}
}

#Preview {
	AppIntroductionView(viewModel: AppIntroductionViewModel(coordinator: nil))
}
