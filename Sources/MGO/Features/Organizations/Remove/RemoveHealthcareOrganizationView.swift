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
	@Published var healthcareOrganization: OrganizationSearch.Organization
	
	/// Dependency Injectable Healthcare Organization Store
	@Injected(\.healthcareOrganizationRepository) private var healthcareOrganizationRepository
	
	/// Dependency Injectable Data Store
	@Injected(\.dataStore) private var dataStore
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil, healthcareOrganization: OrganizationSearch.Organization) {
		
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
	@MainActor func reduce(_ action: RemoveHealthcareOrganizationViewModel.Action) {
		
		switch action {
			case .removeOrganization:
				dataStore.removeRecords(for: healthcareOrganization.identifier)
				try? healthcareOrganizationRepository.remove(healthcareOrganization)
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
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
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
			
			topView
			
		} bottomView: {
			
			bottomView
		}
		.when(isPresentedAsSheet, transform: { view in
			view
				.withToolbarCloseButton(osVersionChecker.available(version: .iOS(.v26))) {
					viewModel.reduce(.closeSheet)
				}
		})
		.background(theme.backgrounds.primary.ignoresSafeArea())
	}
	
	/// The top content of the scroll view
	@ViewBuilder private var topView: some View {
		VStack(spacing: ViewTraits.General.padding) {
			HStack {
				Spacer()
				Image(ImageResource.Details.bigTrashcan)
					.background {
						Circle()
							.foregroundStyle(theme.backgrounds.secondary)
					}
				Spacer()
			}
			.padding(.top, ViewTraits.Image.bottom)
			.padding(.bottom, ViewTraits.Image.bottom)
			
			Text(
				String(
					format: String(localized: "remove_organization.heading"),
					arguments: ["\(viewModel.healthcareOrganization.displayName ?? "")"]
				)
			)
			.typography(.headingExtraLarge)
			.foregroundStyle(theme.labels.primary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityAddTraits(.isHeader)
			.accessibilityIdentifier("remove_organization.heading")
			
			Text(
				String(
					format: String(localized: "remove_organization.subheading"),
					arguments: ["\(viewModel.healthcareOrganization.displayName ?? "")"]
				)
			)
			.typography(.bodyMedium)
			.foregroundStyle(theme.labels.primary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityIdentifier("remove_organization.subheading")
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.padding(.top, ViewTraits.Navigation.padding)
	}
	
	/// Get the call to action buttons view
	/// - Returns: View containing the call to action buttons
	@ViewBuilder private var bottomView: some View {
		
		VStack(spacing: ViewTraits.Button.spacing) {
			
			CallToActionButton(
				"remove_organization.yes_delete",
				style: .tonal(rounded: osVersionChecker.available(version: .iOS(.v26)))
			) {
				viewModel.reduce(.removeOrganization)
			}
			.accessibilityIdentifier("remove_organization.remove")
			
			CallToActionButton(
				"remove_organization.no_cancel",
				style: .solid(
					rounded: osVersionChecker.available(version: .iOS(.v26)),
					narrow: false
				)
			) {
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
