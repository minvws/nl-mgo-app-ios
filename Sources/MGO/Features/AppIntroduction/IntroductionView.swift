/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
		case closeBanner
		case onDisappear
	}
	
	/// Any banner to display?
	@Published var banner: Feedback?
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)?, showAccountDeletedBanner: Bool = false) {
		self.coordinator = coordinator
		
		if showAccountDeletedBanner {
			banner = Feedback(
				title: String(localized: "banner.account_removed.heading"),
				subtitle: String(localized: "banner.account_removed.subheading"),
				type: .success
			)
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: IntroductionViewModel.Action) {
		switch action {
			case .nextButttonPressed:
				coordinator?.handle(Coordination.Action.nextButtonPressedOnIntroduction)
			case .closeBanner, .onDisappear:
				banner = nil
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
	
	@Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
	
	/// Magic numbers
	private struct ViewTraits {
		enum Image {
			static let insets = EdgeInsets( top: 0, leading: 20, bottom: 24, trailing: 20)
			static let height: CGFloat = 161
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
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum Banner {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 24, trailing: 16)
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(alignment: .leading, spacing: 0) {
				
				if let banner = viewModel.banner {
					
					BannerView(banner) {
						// User pressed on the close button
						withAnimation {
							viewModel.reduce(.closeBanner)
						}
					}
					.padding(ViewTraits.Banner.insets)
				}
				
				if showImage {
					HStack {
						Spacer()
						Image(.onboarding)
							.resizable()
							.scaledToFit()
							.frame(height: ViewTraits.Image.height)
							.accessibilityHidden(true)
						.padding(ViewTraits.Image.insets)
						Spacer()
					}
					.frame(maxWidth: .infinity, alignment: .topLeading)
				}
				
				Text("introduction.heading")
					.rijksoverheidStyle(font: .bold, style: .title)
					.padding(ViewTraits.Title.insets)
					.accessibilityAddTraits(.isHeader)
					.fixedSize(horizontal: false, vertical: true)
					.accessibilityIdentifier("introduction.heading")
				
				SplittedText(key: "introduction.subheading", spacing: ViewTraits.Text.spacing)
					.rijksoverheidStyle(font: .regular, style: .body)
					.padding(ViewTraits.Text.insets)
				
				Spacer()
			}
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
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden()
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onDisappear {
			viewModel.reduce(.onDisappear)
		}
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		IntroductionView(viewModel: IntroductionViewModel(coordinator: nil, showAccountDeletedBanner: true))
	}
}
