/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

class UpdateRequiredViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case actionButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)?) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: UpdateRequiredViewModel.Action) {
		switch action {
			case .actionButtonPressed:
				coordinator?.handle(Coordination.Action.showAppStore)
		}
	}
}

struct UpdateRequiredView: View {
	
	/// The view model
	@StateObject var viewModel: UpdateRequiredViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Boolean to determine if the header image should be shown (hidden in landscape)
	@State var showImage = true
	
	@Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
	
	/// Magic numbers
	private struct ViewTraits {
		enum Image {
			static let insets = EdgeInsets( top: 0, leading: 20, bottom: 24, trailing: 20)
			static let padding: CGFloat = 70
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
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(alignment: .leading, spacing: 0) {
				
				if showImage {
					HStack {
						Spacer(minLength: ViewTraits.Image.padding)
						Image(ImageResource.Woman.womanWithPhoneCog)
							.resizable()
							.scaledToFit()
							.accessibilityHidden(true)
						.padding(ViewTraits.Image.insets)
						Spacer(minLength: ViewTraits.Image.padding)
					}
					.frame(maxWidth: .infinity, alignment: .topLeading)
				}
				
				Text("update_required.heading")
					.rijksoverheidStyle(font: .bold, style: .title)
					.padding(ViewTraits.Title.insets)
					.accessibilityAddTraits(.isHeader)
					.fixedSize(horizontal: false, vertical: true)
					.accessibilityIdentifier("update_required.heading")
				
				SplittedText(key: "update_required.subheading", spacing: ViewTraits.Text.spacing)
					.rijksoverheidStyle(font: .regular, style: .body)
					.padding(ViewTraits.Text.insets)
					.accessibilityIdentifier("update_required.subheading")
				
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
			
			CallToActionButton("update_required.download") {
				viewModel.reduce(.actionButtonPressed)
			}
			.accessibilityIdentifier("update_required.download")
			.padding(ViewTraits.Button.padding)
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden()
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		UpdateRequiredView(viewModel: UpdateRequiredViewModel(coordinator: nil))
	}
}
