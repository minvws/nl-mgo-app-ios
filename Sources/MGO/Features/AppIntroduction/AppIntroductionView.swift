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
	func reduce(_ action: Action) {
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
	
	/// Magic numbers
	private struct ViewTraits {
		enum Image {
			static let top: CGFloat = 50
		}
		enum Title {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 16, trailing: 16)
		}
		enum Text {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 0, trailing: 16)
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
							Spacer()
						}
						.accessibilityHidden(true)
						.padding(.top, ViewTraits.Image.top)
					}
					
					Text("onboarding_title")
						.rijksoverheidStyle(font: .bold, style: .title2)
						.padding(ViewTraits.Title.insets)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.padding(.top, showImage ? 0 : ViewTraits.Image.top)
						.accessibilityAddTraits(.isHeader)
					
					Text("onboarding_body")
						.rijksoverheidStyle(font: .regular, style: .body)
						.padding(ViewTraits.Text.insets)
						.frame(maxWidth: .infinity, alignment: .topLeading)
					
					Spacer()
				}
				.foregroundColor(Color.Styleguide.black)
				.onRotate { newOrientation in
					// Hide the image in landscape on a phone, show on other devices
					showImage = !newOrientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone
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
