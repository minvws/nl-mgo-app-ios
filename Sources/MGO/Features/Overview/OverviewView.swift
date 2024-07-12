/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class OverviewViewModel: ObservableObject {
	
	/// The state for the overview scene
	enum State: Equatable {
		case empty
		case list([MgoOrganization])
	}
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The state of the view
	@Published var state: OverviewViewModel.State
	
	/// A toast
	@Published var toast: Toast?
	
	/// Token for the observatory (needed for unregister)
	private var observerToken: Observatory.ObserverToken?

	/// Token for the observatory (needed for unregister)
	private var removalObserverToken: Observatory.ObserverToken?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case onAppear
		case search
		case details(MgoOrganization)
		case closeToast
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		
		self.coordinator = coordinator
		self.state = .empty
		
		registerObservers()
	}
	
	// Listen to changes in the stored organizations list
	private func registerObservers() {
		
		self.observerToken = Current.healthcareOrganizationStore.observatory.append { [weak self] changed in
			if changed {
				self?.loadHealthcareOrganizations()
			}
		}

		self.removalObserverToken = Current.healthcareOrganizationStore.removalObservatory.append { [weak self] organization in
			
			self?.toast = Toast(
				title: String(
					format: String(localized: "toast.organization_removed.heading"),
					arguments: ["\(organization.display_name)"]
				),
				subtitle: String(localized: "toast.organization_removed.subheading"),
				type: .success
			)
			Haptic.light()
		}
	}
	
	deinit {
		// Remove as observer
		observerToken.map(Current.healthcareOrganizationStore.observatory.remove)
		removalObserverToken.map(Current.healthcareOrganizationStore.removalObservatory.remove)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: OverviewViewModel.Action) {
		
		switch action {
		
			case .onAppear:
				loadHealthcareOrganizations()
			
			case .search:
				toast = nil
				coordinator?.handle(Coordination.Action.addHealthcareOrganization)
			
			case .details(let healthcareOrganization):
				toast = nil
				coordinator?.handle(Coordination.Action(
					identifier: "showHealthcareOrganization",
					params: ["healthcareOrganization": healthcareOrganization])
				)
			
			case .closeToast:
				toast = nil
		}
	}
	
	/// fetch the healthcare organizations
	private func loadHealthcareOrganizations() {

		let organizations = Current.healthcareOrganizationStore.organizations
		if organizations.isEmpty {
			state = .empty
		} else {
			state = .list(organizations)
		}
	}
}

struct OverviewView: View {
	
	/// The View Model
	@StateObject var viewModel: OverviewViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 24
		}
		enum Image {
			static let insets = EdgeInsets( top: 0, leading: 50, bottom: 0, trailing: 50)
		}
		enum List {
			static let spacing: CGFloat = 4
			static let top: CGFloat = 8
		}
		enum Button {
			static let insets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
		}
		enum Toast {
			static let insets = EdgeInsets( top: 0, leading: 16, bottom: 24, trailing: 16)
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			if let toast = viewModel.toast {
				
				ToastView(toast) {
					// User pressed on the close button
					withAnimation {
						viewModel.reduce(.closeToast)
					}
				}
				.padding(ViewTraits.Toast.insets)
			}
			
			VStack(spacing: ViewTraits.General.spacing) {
				
				headerView()
				
				switch viewModel.state {
					case .empty:
						noHealthcareOrganizationView()
						.padding(.horizontal, ViewTraits.General.padding)
						
					case let .list(list):
						listHealthcareOrganizationView(list: list)
				}
			}
			
			Spacer()
		} bottomView: {
			
			switch viewModel.state {
				case .empty:
					CallToActionButton("overview.add_organizations") {
						viewModel.reduce(.search)
					}
					.padding(ViewTraits.Button.insets)
					.tag("overview.add_organizations")
				case .list:
					CallToActionButton("overview.add_organization") {
						viewModel.reduce(.search)
					}
					.padding(ViewTraits.Button.insets)
					.tag("overview.add_organization")
			}
		}
		
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarHidden(true)
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.layoutForIPad()
	}
	
	@ViewBuilder func headerView() -> some View {
		
		Text("overview.heading")
			.rijksoverheidStyle(font: .bold, style: .title)
			.foregroundColor(theme.contentPrimary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityAddTraits(.isHeader)
			.padding(.horizontal, ViewTraits.General.padding)
	}
	
	/// Create the empty state view
	/// - Returns: View when the user has no stored healthcare organizations
	@ViewBuilder func noHealthcareOrganizationView() -> some View {
		
		Text("overview.no_organizations_found")
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundStyle(theme.contentTertiary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
		
		Image(ImageResource.Overview.empty)
			.resizable()
			.scaledToFit()
			.accessibilityHidden(true)
			.padding(ViewTraits.Image.insets)
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listHealthcareOrganizationView(list: [MgoOrganization]) -> some View {
		
		Text("overview.subheading")
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundStyle(theme.contentTertiary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.padding(.horizontal, ViewTraits.General.padding)
		
		LazyVStack(spacing: ViewTraits.List.spacing, content: {
			
			ForEach(list, id: \.self) { healthcareOrganization in
				
				ZStack {
					Rectangle()
						.foregroundStyle(.clear)
						.accessibilityLabel(String(
							format: String(localized: "overview.voiceover"),
							arguments: ["\(healthcareOrganization.display_name)"]
						))
						.accessibilityAddTraits(.isButton)
					
					let model = OverviewDecorator.create(healthcareOrganization)
					OverviewCardView(
						model: model,
						perform: {
							viewModel.reduce(.details(healthcareOrganization))
						}
					)
				}
			}
		})
		.padding(.top, ViewTraits.List.top)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		OverviewView(viewModel: OverviewViewModel(coordinator: nil))
	}
}
