/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct DashboardCoordinatorView<T: DashboardCoordinatorProtocol>: View {
	
	/// The coordinator for handling state
	@StateObject private var coordinator: T
	
	/// Initializer
	/// - Parameter appCoordinator: An DashboardCoordinatorProtocol class
	init(coordinator: T) {
		self._coordinator = StateObject(wrappedValue: coordinator)
	}
	
	// The Theme
	@Environment(\.theme) var theme
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		
		TabView(selection: $coordinator.selectedTab) {
			
			Group {
				// First Tab, Overview
				NavigationStackBackport.NavigationStack(path: $coordinator.firstTabPath) {
					coordinator.viewState(for: .showHealthCategories)
						.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
							coordinator.viewState(for: state)
						}
				}
				.tabItem {
					Image(coordinator.selectedTab == DashboardTab.healthCategories.rawValue ? ImageResource.Tab.Selected.overview : ImageResource.Tab.Unselected.overview)
					Text("bottombar.overview")
						.rijksoverheidStyle(font: .bold, style: .body)
				}
				.tag(DashboardTab.healthCategories.rawValue)
				.accessibilityIdentifier("bottombar.overview")
				
				// Second Tab, Healthcare organizations
				NavigationStackBackport.NavigationStack(path: $coordinator.secondTabPath) {
					coordinator.viewState(for: .overview)
						.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
							coordinator.viewState(for: state)
						}
				}
				.tabItem {
					Image(coordinator.selectedTab == DashboardTab.overview.rawValue ? ImageResource.Tab.Selected.providers : ImageResource.Tab.Unselected.providers)
					Text("bottombar.healthcareproviders")
						.rijksoverheidStyle(font: .bold, style: .body)
				}
				.tag(DashboardTab.overview.rawValue)
				.accessibilityIdentifier("bottombar.healthcareproviders")
				
				// Third Tab, Settings
				coordinator.viewState(for: .settings)
				.tabItem {
					Image(coordinator.selectedTab == DashboardTab.settings.rawValue ? ImageResource.Tab.Selected.settings : ImageResource.Tab.Unselected.settings)
					Text("bottombar.settings")
						.rijksoverheidStyle(font: .bold, style: .body)
				}
				.tag(DashboardTab.settings.rawValue)
				.accessibilityIdentifier("bottombar.settings")
			}
			.tint(theme.interactionTertiaryDefaultText)
		}
		.onAppear(perform: {
			styleStandardAppearance()
			styleScrollEdgeAppearance()
		})
		.navigationBarHidden(true)
		.navigationBarBackButtonHidden()
		.inspectableSheet(
			isPresented: $coordinator.rootStateForSheet.presence(),
			onDismiss: {
				// Called when the sheet is closed by dragging.
				coordinator.handle(Coordination.Action.closeSheet)
			},
			content: {
				NavigationStackBackport.NavigationStack(path: $coordinator.pathForSheet) {
					coordinator.viewState(for: coordinator.rootStateForSheet)
						.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
							coordinator.viewState(for: state)
						}
						.navigationBarBackButtonHidden(true)
						.navigationBarTitleDisplayMode(.inline)
				}
			}
		)
	}
	
	/// Style the tab bar
	private func styleStandardAppearance() {
		
		let tabBarAppearance = commonTabBarAppearance()
		if colorScheme == .light {
			tabBarAppearance.shadowColor = UIColor(Color.black.opacity(0.15))
		} else {
			tabBarAppearance.shadowColor = UIColor(Color.white.opacity(0.15))
		}
		tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
		UITabBar.appearance().standardAppearance = tabBarAppearance
	}
	
	/// Style the tab bar
	private func styleScrollEdgeAppearance() {
		
		let tabBarAppearance = commonTabBarAppearance()
		UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
	}
	
	/// Create a common tab bar appearance
	/// - Returns: the common tab bar appearance
	private func commonTabBarAppearance() -> UITabBarAppearance {
		let tabBarAppearance = UITabBarAppearance()
		tabBarAppearance.configureWithTransparentBackground()
		
		for appearance in [tabBarAppearance.stackedLayoutAppearance,
						   tabBarAppearance.inlineLayoutAppearance,
						   tabBarAppearance.compactInlineLayoutAppearance] {
			
			appearance.selected.iconColor = UIColor(theme.interactionTertiaryDefaultText)
			appearance.selected.titleTextAttributes =
			[
				.foregroundColor: UIColor(theme.interactionTertiaryDefaultText),
				.paragraphStyle: NSParagraphStyle.default
			]
			appearance.normal.titleTextAttributes = [
				.foregroundColor: UIColor(theme.symbolPrimary),
				.paragraphStyle: NSParagraphStyle.default
			]
			appearance.normal.iconColor = UIColor(theme.symbolPrimary)
		}
		
		return tabBarAppearance
	}
}

#Preview {
	DashboardCoordinatorView(coordinator: DashboardCoordinator(parentCoordinator: nil))
}
