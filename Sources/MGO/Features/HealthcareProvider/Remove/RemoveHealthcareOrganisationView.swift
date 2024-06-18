/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class RemoveHealthcareOrganisationViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare provider to display
	@Published var healthcareProvider: HealthcareProvider
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil, healthcareProvider: HealthcareProvider) {
		
		self.coordinator = coordinator
		self.healthcareProvider = healthcareProvider
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case removeOrganisation
		case cancel
		case closeSheet
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: RemoveHealthcareOrganisationViewModel.Action) {
		
		switch action {
	
			case .cancel:
				break
			case .removeOrganisation:
				break
			case .closeSheet:
				break
		}
	}
}

struct RemoveHealthcareOrganisationView: View {
	
	/// The View Model
	@StateObject var viewModel: RemoveHealthcareOrganisationViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum Button {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
			static let spacing: CGFloat = 16
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum Image {
			static let size: CFloat = 102
			static let bottom: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(spacing: ViewTraits.General.padding) {
				
				HStack {
					Spacer()
					Image(ImageResource.Details.bigTrashcan)
					Spacer()
				}
				.padding(.bottom, ViewTraits.Image.bottom)
				
				Text(String(
					format: String(localized: "remove_healthcare_organisation.page.heading"),
					   arguments: ["\(viewModel.healthcareProvider.display_name)"]
				   ))
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.padding(.bottom, ViewTraits.General.padding)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Text(String(
						format: String(localized: "remove_healthcare_organisation.page.subheading"),
						arguments: ["\(viewModel.healthcareProvider.display_name)"]
					))
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentTertiary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
			}
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			
			VStack(spacing: ViewTraits.Button.spacing) {
				
				CallToActionButton("remove_healthcare_organisation.remove_button.title", style: .secondary) {
					viewModel.reduce(.removeOrganisation)
				}
				.tag("remove")
				
				CallToActionButton("remove_healthcare_organisation.cancel_button.title") {
					viewModel.reduce(.cancel)
				}
				.tag("cancel")
				
			}
			.padding(ViewTraits.Button.insets)
			.padding(.top, ViewTraits.General.padding)
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden(true)
		.navigationBarHidden(false)
		.if(isPresentedAsSheet, transform: { view in
			view
				.toolbar {
					ToolbarItem(content: { CloseButton {
						viewModel.reduce(.closeSheet)
					}})
				}
		})
		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
}

#Preview {
	
	NavigationView {
		RemoveHealthcareOrganisationView(viewModel: RemoveHealthcareOrganisationViewModel(
			coordinator: nil,
			healthcareProvider: PreviewContent.healthcareOrganisation
		)
		)
	}
}
