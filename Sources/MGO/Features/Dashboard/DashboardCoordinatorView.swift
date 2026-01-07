/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	var body: some View {
		
		TabView(selection: $coordinator.selectedTab) {
			
			Group {
				
				overviewTab()
				
				healthcareProvidersTab()
				
				settingsTab()
				
			}
			.tint(theme.actions.ghost.text)
		}
		.onAppear(perform: {
			styleStandardAppearance()
			styleScrollEdgeAppearance()
		})
		.navigationBarHidden(true)
		.navigationBarBackButtonHidden()
	}
	
	// First Tab, Overview
	@ViewBuilder private func overviewTab() -> some View {
		
		coordinator.view(for: .healthCategories)
			.tabItem {
				if osVersionChecker.available(version: .iOS(.v26)) {
					Image(
						coordinator.selectedTab == DashboardTab.healthCategories.rawValue ? ImageResource.Tab.Selected.IOS26.overview : ImageResource.Tab.Unselected.IOS26.overview
					)
				} else {
					Image(coordinator.selectedTab == DashboardTab.healthCategories.rawValue ? ImageResource.Tab.Selected.overview : ImageResource.Tab.Unselected.overview)
				}
				Text("bottombar.overview")
					.typography(.bodyMedium, isBold: true)
					.accessibilityIdentifier("bottombar.overview")
			}
			.tag(DashboardTab.healthCategories.rawValue)
	}
	
	// Second Tab, Healthcare organizations
	@ViewBuilder private func healthcareProvidersTab() -> some View {
		
		coordinator.view(for: .healthcareOrganizations)
			.tabItem {
				if osVersionChecker.available(version: .iOS(.v26)) {
					Image(coordinator.selectedTab == DashboardTab.healthcareOrganizations.rawValue ? ImageResource.Tab.Selected.IOS26.providers : ImageResource.Tab.Unselected.IOS26.providers)
				} else {
					Image(coordinator.selectedTab == DashboardTab.healthcareOrganizations.rawValue ? ImageResource.Tab.Selected.providers : ImageResource.Tab.Unselected.providers)
				}
				Text("bottombar.healthcareproviders")
					.typography(.bodyMedium, isBold: true)
					.accessibilityIdentifier("bottombar.healthcareproviders")
			}
			.tag(DashboardTab.healthcareOrganizations.rawValue)
	}
	
	// Third Tab, Settings
	@ViewBuilder private func settingsTab() -> some View {
		
		coordinator.view(for: .settings)
			.tabItem {
				if osVersionChecker.available(version: .iOS(.v26)) {
					Image(coordinator.selectedTab == DashboardTab.settings.rawValue ? ImageResource.Tab.Selected.IOS26.settings : ImageResource.Tab.Unselected.IOS26.settings)
				} else {
					Image(coordinator.selectedTab == DashboardTab.settings.rawValue ? ImageResource.Tab.Selected.settings : ImageResource.Tab.Unselected.settings)
				}
				Text("bottombar.settings")
					.typography(.bodyMedium, isBold: true)
					.accessibilityIdentifier("bottombar.settings")
			}
			.tag(DashboardTab.settings.rawValue)
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
		
		let normalColor = UIColor(osVersionChecker
			.available(version: .iOS(.v26)) ? theme.labels.primary : theme.symbols.primary
		)
		for appearance in [tabBarAppearance.stackedLayoutAppearance,
						   tabBarAppearance.inlineLayoutAppearance,
						   tabBarAppearance.compactInlineLayoutAppearance] {
			
			appearance.selected.iconColor = UIColor(theme.categories.rijkslint)
			appearance.selected.titleTextAttributes =
			[
				.foregroundColor: UIColor(theme.categories.rijkslint),
				.paragraphStyle: NSParagraphStyle.default
			]
			appearance.normal.iconColor = normalColor
			appearance.normal.titleTextAttributes = [
				.foregroundColor: normalColor,
				.paragraphStyle: NSParagraphStyle.default
			]
		}
		
		return tabBarAppearance
	}
}

#Preview {
	DashboardCoordinatorView(coordinator: DashboardCoordinator(parentCoordinator: nil))
}
