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
	@Published var toast: Feedback?
	
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
			
			self?.toast = Feedback(
				title: String(localized: "toast.organization_removed.heading"),
				subtitle: String(localized: "toast.organization_removed.subheading"),
				type: .success,
				perform: { [weak self] in
					// Undo deletion
					try? Current.healthcareOrganizationStore.store(organization)
					withAnimation {
						self?.toast = nil
					}
				}
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
					identifier: Coordination.Action.showHealthcareOrganization.identifier,
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
			static let spacing: CGFloat = 8
		}
		enum Account {
			static let size: CGFloat = 32
		}
		enum Image {
			static let insets = EdgeInsets( top: 0, leading: 50, bottom: 0, trailing: 50)
		}
		enum List {
			static let rowInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let spacing: CGFloat = 16
			static let padding: CGFloat = 16
		}
		enum NoResults {
			static let top: CGFloat = 36
		}
	}
	
	var body: some View {

		Group {
			switch viewModel.state {
				case .empty:
					ScrollView {
						VStack(spacing: ViewTraits.General.spacing) {
							
							headerView()
							
							noHealthcareOrganizationView()
							
							Spacer()
						}
					}
					.padding(.horizontal, ViewTraits.General.padding)
				
				case let .list(list):
					
					VStack(spacing: ViewTraits.General.spacing) {
						
						headerView()
							.padding(.horizontal, ViewTraits.General.padding)
						
						listHealthcareOrganizationView(list: list)
						
						Spacer()
					}
			}
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.toast(viewModel.toast) {
			viewModel.reduce(.closeToast)
		}
		.layoutForIPad()
		
	}
	
	@ViewBuilder func headerView() -> some View {
	
		HStack {
			Text("healthcare_organizations.heading")
				.rijksoverheidStyle(font: .bold, style: .title)
				.foregroundColor(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
				.accessibilityIdentifier("healthcare_organizations.heading")
			
			Spacer()
			
			Image(ImageResource.Overview.accountCircle)
				.resizable()
				.frame(width: ViewTraits.Account.size, height: ViewTraits.Account.size)
				.accessibilityHidden(true)
		}
	}
	
	/// Create the empty state view
	/// - Returns: View when the user has no stored healthcare organizations
	@ViewBuilder func noHealthcareOrganizationView() -> some View {
		
		EmptyListView(
			icon: Image(ImageResource.Woman.womanWithPhone),
			heading: "overview.empty.heading",
			subHeading: "overview.empty.subheading"
		)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.top, ViewTraits.NoResults.top)
		
		CallToActionButton("overview.empty.action") {
			viewModel.reduce(.search)
		}
		.accessibilityIdentifier("overview.empty.action")
	}
	
	/// Create the list state view
	/// - Parameter list: The list of healthcare organizations
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listHealthcareOrganizationView(list: [MgoOrganization]) -> some View {
		
		List {
			// Top Section with all the healthcare organizations
			Section {
				ForEach(list, id: \.self) { healthcareOrganization in
					rowFor(
						title: healthcareOrganization.display_name,
						imageResource: ImageResource.Overview.chevronRight) {
							viewModel.reduce(.details(healthcareOrganization))
						}
				}
			}
			
			// Bottom section for add button
			Section {
				rowFor(
					title: String(localized: "organization_list.add_organization"),
					imageResource: ImageResource.Overview.add) {
						viewModel.reduce(.search)
					}
			}
		}
		.listStyle(.insetGrouped)
		.backportListSectionSpacing(ViewTraits.List.spacing)
	}
	
	/// The view for a row of the healthcare organizations list
	/// - Parameters:
	///   - title: the title of the row
	///   - imageResource: the image resource for the trailing end
	///   - action: the action when tapped on
	/// - Returns: row view
	@ViewBuilder func rowFor(title: String, imageResource: ImageResource, action: @escaping () -> Void) -> some View {
		
		Section {
			Button {
				action()
			} label: {
				HStack {
					Text(title)
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundStyle(theme.contentPrimary)
					
					Spacer()
					
					Image(imageResource)
						.foregroundColor(theme.iconsSecondary)
				}
				.padding(ViewTraits.List.padding)
			}
			.frame( maxWidth: .infinity, alignment: .leading)
			.buttonStyle(HoverButtonStyle())
		}
		.listRowInsets(ViewTraits.List.rowInset)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		OverviewView(viewModel: OverviewViewModel(coordinator: nil))
	}
}
