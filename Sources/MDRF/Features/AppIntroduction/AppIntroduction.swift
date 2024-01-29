/*
 * Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzFoundation
import GifzUI

struct AppIntroduction: View {
	@State var showImage = true
	
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
			
			Color.background
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
						.rijksoverheidStyle(font: .bold, style: .title3)
						.padding(ViewTraits.Title.insets)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.padding(.top, showImage ? 0 : ViewTraits.Image.top)
					
					Text("onboarding_body")
						.rijksoverheidStyle(font: .regular, style: .body)
						.padding(ViewTraits.Text.insets)
						.frame(maxWidth: .infinity, alignment: .topLeading)
					
					Spacer()
				}
				.foregroundColor(.blackText)
				.onRotate { newOrientation in
					// Hide the image in landscape on a phone, show on other devices
					showImage = !newOrientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone
				}
			}, bottomView: {
				
				Button(
					action: {},
					label: {
//						NavigationLink(destination: PrivacyView()) {
							SkyBlueButton("onboarding_action")
//						}
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
	AppIntroduction()
}
