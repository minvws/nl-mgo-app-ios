/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class RemoteAuthenticationViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case loginWithDigiD
		case loginWithEIDAS
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// Initializer
	/// - Parameter coordinator: The coordinator
	init(coordinator: (any Coordinator)?) {
		
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		
		switch action {
			case .loginWithDigiD, .loginWithEIDAS:
				coordinator?.handle(Coordination.Action.loggedInWithDigiD)
		}
	}
}

struct RemoteAuthenticationView: View {
	
	/// The view model
	@StateObject var viewModel: RemoteAuthenticationViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum Button {
			static let top: CGFloat = 8
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		
		ScrollView {
			
			VStack(spacing: ViewTraits.General.padding) {
				
				Group {
					
					Text("remoteAuthentication_title")
						.rijksoverheidStyle(font: .bold, style: .title)
						.accessibilityAddTraits(.isHeader)
					
					Text("remoteAuthentication_body")
						.rijksoverheidStyle(font: .regular, style: .body)
				}
				.foregroundStyle(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				
				VStack(spacing: ViewTraits.Button.spacing, content: {
					
					DisclosureWithImageButton(
						title: "remoteAuthentication_digid",
						image: ImageResource.RemoteAuthentication.digid) {
							viewModel.reduce(.loginWithDigiD)
						}
					
					DisclosureWithImageButton(
						title: "remoteAuthentication_eidas",
						image: ImageResource.RemoteAuthentication.eidas) {
							viewModel.reduce(.loginWithEIDAS)
						}
				})
				.padding(.top, ViewTraits.Button.top)
			}
			.padding(.horizontal, ViewTraits.General.padding)
			.navigationBarBackButtonHidden(true)
			.navigationBarHidden(false)
			.navigationBarTitleDisplayMode(.inline)
			.background(theme.backgroundPrimary.ignoresSafeArea())
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		RemoteAuthenticationView(viewModel: RemoteAuthenticationViewModel(coordinator: nil)
		)
	}
}

struct DisclosureWithImageButton: View {
	
	/// The title for the button
	var title: LocalizedStringKey
	
	/// The image for the button
	var image: ImageResource
	
	/// The action to perform
	var action: (() -> Void)?
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let size: CGFloat = 32
		}
		enum Chevron {
			static let size: CGFloat = 32
		}
		enum General {
			static let padding: CGFloat = 16
			static let radius: CGFloat = 8
		}
	}
	
	/// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
		
		Button(action: {
			action?()
		}, label: {
			
			HStack(alignment: .center, spacing: 0) {
				
				Rectangle()
					.foregroundColor(.clear)
					.frame(width: ViewTraits.Image.size, height: ViewTraits.Image.size)
					.background(
						Image(image)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: ViewTraits.Image.size, height: ViewTraits.Image.size)
					)
				
				Text(title)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundColor(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.leading, ViewTraits.General.padding)
				
				Image(ImageResource.Localisation.arrowForward)
					.foregroundStyle(theme.iconsPrimary)
					.frame(width: ViewTraits.Chevron.size, height: ViewTraits.Chevron.size, alignment: .center)
				
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.cardify(setBackground: false)
		})
		.buttonStyle(HoverButtonStyle())
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.General.radius))
	}
}
