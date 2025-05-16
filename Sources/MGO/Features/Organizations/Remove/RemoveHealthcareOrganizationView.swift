/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class RemoveHealthcareOrganizationViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare organization to display
	@Published var healthcareOrganization: MgoOrganization
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil, healthcareOrganization: MgoOrganization) {
		
		self.coordinator = coordinator
		self.healthcareOrganization = healthcareOrganization
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case removeOrganization
		case cancel
		case closeSheet
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: RemoveHealthcareOrganizationViewModel.Action) {
		
		switch action {
			case .removeOrganization:
				Current.dataStore.removeRecords(for: healthcareOrganization.identifier)
				try? Current.healthcareOrganizationStore.remove(healthcareOrganization)
				coordinator?.handle(.removedHealthcareOrganization)
			
			case .cancel, .closeSheet:
				coordinator?.handle(.closeSheet)
		}
	}
}

struct RemoveHealthcareOrganizationView: View {
	
	/// The View Model
	@StateObject var viewModel: RemoveHealthcareOrganizationViewModel
	
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
			static let bottom: CGFloat = 16
			static let top: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(spacing: ViewTraits.General.padding) {
				
				HStack {
					Spacer()
					Image(ImageResource.Details.bigTrashcan)
						.background {
							Circle()
								.foregroundStyle(theme.backgroundSecondary)
						}
					Spacer()
				}
				.padding(.top, ViewTraits.Image.bottom)
				.padding(.bottom, ViewTraits.Image.bottom)
				
				Text(String(
					format: String(localized: "remove_organization.heading"),
					arguments: ["\(viewModel.healthcareOrganization.display_name)"]
				))
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.accessibilityIdentifier("remove_organization.heading")
				
				Text(String(
						format: String(localized: "remove_organization.subheading"),
						arguments: ["\(viewModel.healthcareOrganization.display_name)"]
				))
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityIdentifier("remove_organization.subheading")
			}
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			
			bottomView()
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden(true)
		.navigationBarHidden(false)
		.when(isPresentedAsSheet, transform: { view in
			view
				.withToolbarCloseButton {
					viewModel.reduce(.closeSheet)
				}
		})
		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
	
	/// Get the call to action buttons view
	/// - Returns: View containing the call to action buttons
	@ViewBuilder func bottomView() -> some View {
		
		VStack(spacing: ViewTraits.Button.spacing) {
			
			CallToActionButton("remove_organization.yes_delete", style: .secondary) {
				viewModel.reduce(.removeOrganization)
			}
			.accessibilityIdentifier("remove_organization.remove")
			
			CallToActionButton("remove_organization.no_cancel") {
				viewModel.reduce(.cancel)
			}
			.accessibilityIdentifier("remove_organization.cancel")
			
		}
		.padding(ViewTraits.Button.insets)
		.padding(.top, ViewTraits.General.padding)
	}
}

#Preview {
	
	NavigationView {
		RemoveHealthcareOrganizationView(
			viewModel: RemoveHealthcareOrganizationViewModel(
				coordinator: nil,
				healthcareOrganization: PreviewContent.healthcareOrganization
			)
		)
	}
}
