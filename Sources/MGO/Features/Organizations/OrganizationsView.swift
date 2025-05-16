/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class OrganizationsViewModel: ObservableObject {
	
	/// The state for the overview scene
	enum State: Equatable {
		case empty
		case list([MgoOrganization])
	}
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The state of the view
	@Published var state: OrganizationsViewModel.State
	
	/// A toast
	@Published var toast: Feedback?
	
	/// Token for the observatory (needed for unregister)
	private var observerToken: Observatory.ObserverToken?
	
	/// A list of the organizations when the page was loaded
	private var originalOrganizations: [MgoOrganization] = []
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case onAppear
		case search
		case details(MgoOrganization)
		case closeToast
		case showToast(title: String, subtitle: String)
		case undo
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		
		self.coordinator = coordinator
		self.state = .empty
		self.originalOrganizations = Current.healthcareOrganizationStore.organizations
		registerObservers()
	}
	
	/// Listen to changes in the stored organizations list
	private func registerObservers() {
		
		self.observerToken = Current.healthcareOrganizationStore.observatory.append { [weak self] _, reason in
			self?.handleOrganizationChanges(reason)
		}
	}
	
	/// Handle changes in the organizations list
	/// - Parameters:
	///   - reason: the reason the list has changed
	func handleOrganizationChanges(_ reason: HealthcareOrganizationReason) {
		
		logInfo("OrganizationsViewModel Reason: \(reason)")
		loadHealthcareOrganizations()
		switch reason {
			case .added:
				// Nothing to do
				break
			case .removed:
				reduce(
					.showToast(
						title: String(localized: "toast.organization_removed.heading"),
						subtitle: String(localized: "toast.organization_removed.subheading")
					)
				)
			case .changed:
				reduce(
					.showToast(
						title: String(localized: "toast.organizations_changed.heading"),
						subtitle: String(localized: "toast.organizations_changed.subheading")
					)
				)
		}
	}
	
	deinit {
		// Remove as observer
		observerToken.map(Current.healthcareOrganizationStore.observatory.remove)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: OrganizationsViewModel.Action) {
		
		switch action {
		
			case .onAppear:
				loadHealthcareOrganizations()
			
			case .search:
				toast = nil
				updateOriginalOrganizations()
				coordinator?.handle(Coordination.Action.addHealthcareOrganization)
			
			case .details(let healthcareOrganization):
				toast = nil
				updateOriginalOrganizations()
				coordinator?.handle(Coordination.Action(
					identifier: Coordination.Action.showHealthcareOrganization.identifier,
					params: ["healthcareOrganization": healthcareOrganization])
				)
			
			case .closeToast:
				toast = nil
				updateOriginalOrganizations()
			
			case let .showToast(title, subtitle):
				toast = Feedback(
					title: title,
					subtitle: subtitle,
					type: .success,
					perform: { [weak self] in
						self?.reduce(.undo)
					}
				)
			
			case .undo:
				try? Current.healthcareOrganizationStore.set(originalOrganizations)
				loadHealthcareOrganizations()
				withAnimation {
					Haptic.heavy()
					self.toast = nil
				}
		}
	}
	
	private func updateOriginalOrganizations() {
		// Ignore the changes. This is the new default.
		originalOrganizations = Current.healthcareOrganizationStore.organizations
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

struct OrganizationsView: View {
	
	/// The View Model
	@StateObject var viewModel: OrganizationsViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Are we scrolling
	@State private var isScrolling: Bool = false
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let rowInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let spacing: CGFloat = 16
			static let padding: CGFloat = 16
		}
		enum NoResults {
			static let top: CGFloat = 44
		}
		enum Button {
			static let insets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	var body: some View {

		VStack {
			switch viewModel.state {
				case .empty:
					noHealthcareOrganizationView()
				
				case let .list(list):
					listHealthcareOrganizationView(list: list)
			}
		}
		.navigationBarBackButtonHidden()
		.navigationBarHidden(false)
		.navigationTitle("organizations.heading")
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.toast(viewModel.toast) {
			viewModel.reduce(.closeToast)
		}
		.layoutForIPad()
	}
	
	/// Create the empty state view
	/// - Returns: View when the user has no stored healthcare organizations
	@ViewBuilder func noHealthcareOrganizationView() -> some View {
		
		ScrollViewWithFixedBottom {
			
			ImageContentView(
				icon: Image(ImageResource.Woman.womanWithPhone),
				heading: "common.no_organizations_heading",
				subHeading: "common.no_organizations_subheading",
				subHeadingForegroundColor: theme.contentPrimary
			)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.top, ViewTraits.NoResults.top)
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			
			CallToActionButton(Current.featureFlagManager.isAutomaticLocalizationEnabled ? "common.search_organizations" : "common.add_organizations") {
				viewModel.reduce(.search)
			}
			.accessibilityIdentifier("common.add_organizations")
			.padding(ViewTraits.Button.insets)
		}
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
						title: Sanitizer.sanitize(healthcareOrganization.display_name),
						imageResource: ImageResource.Overview.chevronRight,
						accessibilityIdentifier: Sanitizer.sanitize(healthcareOrganization.display_name)) {
							viewModel.reduce(.details(healthcareOrganization))
						}
				}
			} header: {
				Spacer(minLength: 0).listRowInsets(EdgeInsets())
			}
			
			// Bottom section for add button
			Section {
				rowFor(
					title: String(localized: Current.featureFlagManager.isAutomaticLocalizationEnabled ? "common.search_organizations" : "overview.add_organization"),
					imageResource: ImageResource.Overview.add,
					accessibilityIdentifier: "overview.add_organization") {
						viewModel.reduce(.search)
					}
			}
		}
		.listStyle(.insetGrouped)
		.backportListSectionSpacing(ViewTraits.List.spacing)
		.backportScrollContentBackground(.hidden)
		.environment(\.defaultMinListHeaderHeight, ViewTraits.List.spacing / 2)
	}
	
	/// The view for a row of the healthcare organizations list
	/// - Parameters:
	///   - title: the title of the row
	///   - imageResource: the image resource for the trailing end
	///   - action: the action when tapped on
	/// - Returns: row view
	@ViewBuilder func rowFor(title: String, imageResource: ImageResource, accessibilityIdentifier: String, action: @escaping () -> Void) -> some View {
		
		Button {
			action()
		} label: {
			HStack {
				Text(title)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentPrimary)
				
				Spacer()
				
				Image(imageResource)
					.foregroundColor(theme.symbolSecondary)
			}
			.padding(ViewTraits.List.padding)
		}
		.frame( maxWidth: .infinity, alignment: .leading)
		.buttonStyle(HoverButtonStyle())
		.accessibilityIdentifier(accessibilityIdentifier)
		.listRowInsets(ViewTraits.List.rowInset)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		OrganizationsView(viewModel: OrganizationsViewModel(coordinator: nil))
	}
}
