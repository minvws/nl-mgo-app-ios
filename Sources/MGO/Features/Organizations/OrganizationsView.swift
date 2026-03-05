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
	
	/// The toast auto closure task
	private var dismissTask: Task<Void, Never>?
	
	/// Dependency Healthcare Organization Store
	@Injected(\.healthcareOrganizationRepository) private var healthcareOrganizationRepository
	
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
	@MainActor init(coordinator: (any Coordinator)? = nil) {
		
		self.coordinator = coordinator
		self.state = .empty
		self.originalOrganizations = healthcareOrganizationRepository.organizations
		registerObservers()
	}
	
	/// Listen to changes in the stored organizations list
	@MainActor private func registerObservers() {
		
		self.observerToken = healthcareOrganizationRepository.observatory.append { [weak self] _, reason in
			Task { @MainActor in
				self?.handleOrganizationChanges(reason)
			}
		}
	}
	
	/// Handle changes in the organizations list
	/// - Parameters:
	///   - reason: the reason the list has changed
	@MainActor func handleOrganizationChanges(_ reason: HealthcareOrganizationReason) {
		
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
		observerToken.map(healthcareOrganizationRepository.observatory.remove)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: OrganizationsViewModel.Action) {
		
		switch action {
		
			case .onAppear:
				loadHealthcareOrganizations()
			
			case .search:
				closeToast()
				updateOriginalOrganizations()
				coordinator?.handle(Coordination.Action.addHealthcareOrganization)
			
			case .details(let healthcareOrganization):
				closeToast()
				updateOriginalOrganizations()
				coordinator?.handle(Coordination.Action(
					identifier: Coordination.Action.showHealthcareOrganization.identifier,
					params: ["healthcareOrganization": healthcareOrganization])
				)
			
			case .closeToast:
				closeToast()
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
				Haptic.medium()
				startToastAutoClose()
			
			case .undo:
				try? healthcareOrganizationRepository.set(originalOrganizations)
				loadHealthcareOrganizations()
				
				Haptic.heavy()
				closeToast()
		}
	}
	
	/// Close the toast
	private func closeToast() {
		dismissTask?.cancel()
		withAnimation {
			toast = nil
		}
	}
	
	private func updateOriginalOrganizations() {
		// Ignore the changes. This is the new default.
		originalOrganizations = healthcareOrganizationRepository.organizations
	}
	
	/// fetch the healthcare organizations
	private func loadHealthcareOrganizations() {

		let organizations = healthcareOrganizationRepository.organizations
		if organizations.isEmpty {
			state = .empty
		} else {
			state = .list(organizations)
		}
	}
	
	/// The auto closure timer
	@MainActor
	private func startToastAutoClose() {
		// Cancel any previous task
		dismissTask?.cancel()
		
		// Start a new task that waits for `duration` seconds
		dismissTask = Task {
			try? await Task.sleep(nanoseconds: UInt64(4 * 1_000_000_000))
			// Only hide if the task hasn't been cancelled
			if !Task.isCancelled {
				await MainActor.run {
					withAnimation { toast = nil }
				}
			}
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
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
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
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.toast(viewModel.toast, rounded: osVersionChecker.available(version: .iOS(.v26))) {
			viewModel.reduce(.closeToast)
		}
	}
	
	/// Create the empty state view
	/// - Returns: View when the user has no stored healthcare organizations
	@ViewBuilder func noHealthcareOrganizationView() -> some View {
		
		ScrollViewWithFixedBottom {
			
			ImageContentView(
				icon: Image(ImageResource.Woman.womanWithPhone),
				heading: "common.no_organizations_heading",
				subHeading: "common.no_organizations_subheading",
				configuration: ImageContentView.Configuration(
					subHeadingForegroundColor: theme.labels.primary
				)
			)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.top, ViewTraits.NoResults.top)
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			
			CallToActionButton(
				"common.add_organizations",
				style: .solid(
					rounded: osVersionChecker.available(version: .iOS(.v26)),
					narrow: false
				)
			) {
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
					title: String(localized: "overview.add_organization"),
					imageResource: ImageResource.Overview.add,
					accessibilityIdentifier: "overview.add_organization") {
						viewModel.reduce(.search)
					}
			}
		}
		.listStyle(.insetGrouped)
		.backport.listSectionSpacing(ViewTraits.List.spacing)
		.backport.scrollContentBackground(.hidden)
		.environment(\.defaultMinListHeaderHeight, ViewTraits.List.spacing / 2)
	}
	
	/// The view for a row of the healthcare organizations list
	/// - Parameters:
	///   - title: the title of the row
	///   - imageResource: the image resource for the trailing end
	///   - action: the action when tapped on
	/// - Returns: row view
	@ViewBuilder func rowFor(
		title: String,
		imageResource: ImageResource,
		accessibilityIdentifier: String,
		action: @escaping () -> Void
	) -> some View {
		
		Button {
			action()
		} label: {
			HStack {
				Text(title)
					.typography(.bodyMedium)
					.foregroundStyle(theme.labels.primary)
				
				Spacer()
				
				Image(imageResource)
					.foregroundColor(theme.symbols.secondary)
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
