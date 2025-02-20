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
	
	@State private var isScrolling: Bool = false
	
	/// Initializer
	/// - Parameter appCoordinator: An DashboardCoordinatorProtocol class
	init(coordinator: T) {
		self._coordinator = StateObject(wrappedValue: coordinator)
	}
	
	// The Theme
	@Environment(\.theme) var theme
	
	@ViewBuilder func withDividerIfScrolling(content: () -> some View) -> some View {
		VStack(spacing: 0) {
			if isScrolling {
				NavigationDivider()
			}
			content()
		}
	}
	
	var body: some View {
		
		TabView(selection: $coordinator.selectedTab) {
				
				Group {
					// First Tab, Overview
					NavigationStackBackport.NavigationStack(path: $coordinator.firstTabPath) {
						withDividerIfScrolling {
							coordinator.viewState(for: .showHealthCategories)
								.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
									withDividerIfScrolling {
										coordinator.viewState(for: state)
									}
								}
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
						withDividerIfScrolling {
							coordinator.viewState(for: .overview)
								.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
									withDividerIfScrolling {
										coordinator.viewState(for: state)
									}
								}
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
					NavigationStackBackport.NavigationStack(path: $coordinator.thirdTabPath) {
						withDividerIfScrolling {
							coordinator.viewState(for: .settings)
								.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
									withDividerIfScrolling {
										coordinator.viewState(for: state)
									}
								}
						}
					}
					.tabItem {
						Image(coordinator.selectedTab == DashboardTab.settings.rawValue ? ImageResource.Tab.Selected.settings : ImageResource.Tab.Unselected.settings)
						Text("bottombar.settings")
							.rijksoverheidStyle(font: .bold, style: .body)
					}
					.tag(DashboardTab.settings.rawValue)
					.accessibilityIdentifier("bottombar.settings")
				}
				.tint(theme.interactiveTertiaryDefaultText)
				.onPreferenceChange(IsScrollingPreferenceKey.self, perform: { newValue in
					isScrolling = newValue.last ?? false
				})
			}
			.onAppear(perform: {
				// Brute force styling
				let tabBarAppearance = UITabBarAppearance()
				tabBarAppearance.shadowColor = UIColor(theme.symbolPrimary)
				tabBarAppearance.backgroundColor = UIColor(theme.backgroundSecondary)
				
				for appearance in [tabBarAppearance.stackedLayoutAppearance,
								   tabBarAppearance.inlineLayoutAppearance,
								   tabBarAppearance.compactInlineLayoutAppearance] {
					
					appearance.selected.iconColor = UIColor(theme.interactiveTertiaryDefaultText)
					appearance.selected.titleTextAttributes =
					[
						.foregroundColor: UIColor(theme.interactiveTertiaryDefaultText),
						.paragraphStyle: NSParagraphStyle.default
					]
					appearance.normal.titleTextAttributes = [
						.foregroundColor: UIColor(theme.symbolPrimary),
						.paragraphStyle: NSParagraphStyle.default
					]
					appearance.normal.iconColor = UIColor(theme.symbolPrimary)
				}
				
				// Apply
				UITabBar.appearance().standardAppearance = tabBarAppearance
				UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
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
}

#Preview {
	DashboardCoordinatorView(coordinator: DashboardCoordinator(parentCoordinator: nil))
}
