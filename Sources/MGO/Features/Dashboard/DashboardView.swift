/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class DashboardViewModel: ObservableObject {
	
	enum State: Equatable {
		case empty
		case list([HealthcareProvider])
	}
	
	/// The app coordinator for routing
	weak var coordinator: (any AppCoordinatorProtocol)?
	
	@Published var showResetButton: Bool = false
	@Published var showResetDialog: Bool = false
	
	/// The state of the view
	@Published var state: DashboardViewModel.State
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case resetApplication
		case showResetDialog
		case onAppear
		case search
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any AppCoordinatorProtocol)? = nil) {
		self.coordinator = coordinator
		
		let release = Configuration().getRelease()
		showResetButton = release != Release.production // Show only in Dev, Acc & Test
		
		self.state = .empty
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: DashboardViewModel.Action) {
		
		switch action {
			case .resetApplication:
				coordinator?.handle(AppCoordination.Action.resetApplication)
			case .showResetDialog:
				showResetDialog = true
			case .onAppear:
				loadHealthcareProviders()
			case .search:
				coordinator?.handle(.searchHealthcareProviders)
		}
	}
	
	/// fetch the healthcare providers
	private func loadHealthcareProviders() {

		let providers = Current.healthcareProviderStore.providers
		if providers.isEmpty {
			state = .empty
		} else {
			state = .list(providers)
		}
	}
}

struct DashboardView: View {
	
	/// The View Model
	@StateObject var viewModel: DashboardViewModel
	
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
		}
		enum Button {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(spacing: ViewTraits.General.spacing) {
				
				headerView()
				
				switch viewModel.state {
					case .empty:
						noHealthcareProviderView()
						.padding(.horizontal, ViewTraits.General.padding)
						
					case let .list(list):
						listHealthcareProviderView(list: list)
				}
			}
			
			Spacer()
		} bottomView: {
			
			switch viewModel.state {
				case .empty:
					CallToActionButton("dashboard_search_healthcareProviders") {
						viewModel.reduce(.search)
					}
					.padding(ViewTraits.Button.insets)
					.tag("dashboard_search_healthcareProviders")
				case .list:
					EmptyView()
			}
		}
		
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.confirmationDialog(
			"Reset the application?",
			isPresented: $viewModel.showResetDialog) {
				Button("Reset the application?", role: .destructive) {
					viewModel.reduce(.resetApplication)
				}
			} message: {
				Text(verbatim: "You cannot undo this action")
			}
			.toolbar {
				ToolbarItem(id: "reset", placement: .destructiveAction) {
					if viewModel.showResetButton {
						Button(
							action: {
								viewModel.reduce(.showResetDialog)
							}, label: {
								Image(systemName: "exclamationmark.triangle")
									.foregroundStyle(theme.notificationError)
							}
						)
					}
				}
			}
			.background(theme.backgroundPrimary.ignoresSafeArea())
			.onAppear {
				viewModel.reduce(.onAppear)
			}
	}
	
	@ViewBuilder func headerView() -> some View {
		
		#warning("MGO-197: Header Bar")
		// (https://vws-prd.jira.odc-noord.nl/browse/MGO-197)
		HStack(alignment: .top, spacing: 16) {
			
			Text(verbatim: "Goedemorgen, mevrouw de Bruijn")
				.rijksoverheidStyle(font: .bold, style: .title)
				.foregroundColor(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
			
			Spacer()
			
			Text(verbatim: "WB")
				.rijksoverheidStyle(font: .regular, style: .callout)
				.padding(.horizontal, 6)
				.padding(.vertical, 8)
				.multilineTextAlignment(.center)
				.foregroundStyle(theme.backgroundPrimary)
				.frame(width: 38, height: 38, alignment: .center)
				.background(theme.iconsSecondary)
				.cornerRadius(200)
			
		}
		.padding(.horizontal, ViewTraits.General.padding)
	}
	
	/// Create the empty state view
	/// - Returns: View when the user has no stored healthcare providers
	@ViewBuilder func noHealthcareProviderView() -> some View {
		
		Text("dashboard_intro_empty")
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundStyle(theme.contentTertiary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
		
		Image(ImageResource.Dashboard.empty)
			.resizable()
			.scaledToFit()
			.accessibilityHidden(true)
			.padding(ViewTraits.Image.insets)
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare providers
	@ViewBuilder func listHealthcareProviderView(list: [HealthcareProvider]) -> some View {
		
		Text("dashboard_intro_list")
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundStyle(theme.contentTertiary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.padding(.horizontal, ViewTraits.General.padding)
		
		LazyVStack(spacing: ViewTraits.List.spacing, content: {
			
			ForEach(list, id: \.self) { healthcareProvider in
				
				ZStack {
					Rectangle()
						.foregroundStyle(.clear)
						.accessibilityLabel(String(
							format: String(localized: "dashboard_list_action_voiceover"),
										   arguments: ["\(healthcareProvider.display_name)"]
									   ))
						.accessibilityAddTraits(.isButton)
					
					let model = DashboardDecorator.create(healthcareProvider)
					DashboardCardView(name: model.name, category: model.category)
						.onTapGesture {
							#warning("MGO-240: Show Healthcare Provider")
							// (https://vws-prd.jira.odc-noord.nl/browse/MGO-240)
						}
				}
			}
		})
		
		CallToActionButton("dashboard_add_healthcareProviders") {
			viewModel.reduce(.search)
		}
			.tag("dashboard_add_healthcareProviders")
			.padding(.horizontal, ViewTraits.General.padding)
			.padding(.bottom, ViewTraits.General.padding)

	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		DashboardView(viewModel: DashboardViewModel(coordinator: nil))
	}
}
