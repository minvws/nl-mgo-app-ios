/*
 * Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzFoundation
import GifzUI

struct PrivacyView: View {
	@State private var showingPrivacyStatement = false
	
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum CloseButton {
			static let insets = EdgeInsets( top: 14, leading: 0, bottom: 14, trailing: 14
			)
		}
		enum PrivacyStatement {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	/// The intro text with clikcable link
	/// - Returns: LocalizedStringKey
	private var introText: LocalizedStringKey {
		
		let statement = String(localized: "privacy_statement")
		let link = "**[\(statement)](/privacystatement)**"
		let intro = String(localized: "privacy_intro")
		return LocalizedStringKey(String(format: intro, link))
	}
	
	var body: some View {
		ZStack {
			
			Color.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			ScrollViewWithFixedBottom {
				
				VStack {
					
					Text("privacy_title")
						.rijksoverheidStyle(font: .bold, style: .title3)
						.foregroundColor(.blackText)
						.padding(.bottom, ViewTraits.General.padding)
						.frame(maxWidth: .infinity, alignment: .topLeading)
					
					Text(introText)
						.rijksoverheidStyle(font: .regular, style: .body)
						.padding(.bottom, ViewTraits.General.padding)
						.foregroundColor(.blackText)
						.tint(.hyperlink)
						.environment(\.openURL, OpenURLAction { url in
							guard url.absoluteString.lowercased() == "/privacystatement" else {
								return .discarded
							}
							showingPrivacyStatement.toggle()
							return .handled
						})
					
					Group {
						PrivacyShieldView("privacy_item_1")
						PrivacyShieldView("privacy_item_2")
						PrivacyShieldView("privacy_item_3")
						PrivacyShieldView("privacy_item_4")
					}
					
					Spacer()
				}
				.padding(.horizontal, ViewTraits.General.padding)
			} bottomView: {
				
				Button(
					action: { },
					label: {
//						NavigationLink(destination: DashboardView()) {
							SkyBlueButton("onboarding_action")
//						}
					}
				)
				.padding(ViewTraits.General.padding)
			}
		}
		.sheet(isPresented: $showingPrivacyStatement) {
			
			ZStack {
				
				Color.background
					.ignoresSafeArea()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				
				VStack(alignment: .leading, spacing: 0) {
					
					HStack {
						
						Spacer()
						
						Button(
							action: {
								showingPrivacyStatement.toggle()
							}, label: {
								Image(.close)
							}
						)
						.padding(ViewTraits.CloseButton.insets)
					}
					
					Group {
						
						Text("privacy_statement_title")
							.rijksoverheidStyle(font: .bold, style: .title2)
						
						ScrollView {
							Text("privacy_statement_body")
								.rijksoverheidStyle(font: .regular, style: .body)
						}
					}
					.foregroundColor(.blackText)
					.padding(ViewTraits.PrivacyStatement.insets)
					.fixedSize(horizontal: false, vertical: true)
					
					Spacer()
				}
			}
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton())
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		PrivacyView()
	}
}
