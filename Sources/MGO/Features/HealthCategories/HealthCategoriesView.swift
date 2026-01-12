/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

// swiftlint:disable type_body_length
/// The view for an overview of all the health categories
struct HealthCategoriesView: View {

	/// The View Model
	@StateObject var viewModel: HealthCategoriesViewModel
	
	/// Are we scrolling
	@State private var isScrolling: Bool = false
	
	/// The Theme
	@Environment(\.theme) var theme
	
	@State private var contentSize: CGSize = .zero
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Dependency injectable Feature Flag Manager
	@Injected(\.featureFlagManager) private var featureFlagManager
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let zeroInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let favoritesHeaderInset = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
			static let favoritesHeaderErrorInset = EdgeInsets(top: 28, leading: 16, bottom: 8, trailing: 16)
			static let headerInset = EdgeInsets(top: 10, leading: 0, bottom: 16, trailing: 0)
			static let oldVersionInset = EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16)
			static let categoryHeaderInset = EdgeInsets(top: 28, leading: 16, bottom: 8, trailing: 16)
			static let spacing: CGFloat = 4
			static let padding: CGFloat = 8
			static let headerSpacing: CGFloat = 10
		}
		enum NoResults {
			static let top: CGFloat = 44
		}
		enum Favorites {
			static let cornerRadius: CGFloat = if #available(iOS 26.0, *) {
				26
			} else {
				12
			}
			static let inset: CGFloat = 0.5
			static let rowInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let style = StrokeStyle(lineWidth: 1, dash: [5, 5])
			static let gridSpacing: CGFloat = 10
			static let minWidth: CGFloat = 153
		}
		enum Button {
			static let insets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	var body: some View {
		
		VStack(spacing: 0) {
			
			if viewModel.state.showEmptyView {
				noHealthcareOrganizationView()
			} else {
				categoriesView()
					.backport
					.listSectionSpacing(
						osVersionChecker.available(version: .iOS(.v26)) ? 0 : ViewTraits.List.spacing
					)
					.backport.contentMargins(0)
					.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
			}
		} // VStack
		.navigationBarBackButtonHidden()
		.when(viewModel.state.backButtonTitle != nil, transform: { view in
			view
				.navigationBarItems(leading: BackButton(viewModel.state.backButtonTitle!) {
					viewModel.reduce(.backButtonPressed)
				})
		})
		.when(viewModel.state.canTitleCollapse) { view in
			view.navigationTitle(viewModel.state.heading)
		}
		.when(viewModel.state.belowIOS18 && !viewModel.state.canTitleCollapse) { view in
			view
				.navigationBarTitleDisplayMode(.inline)
		}
		.when(viewModel.state.showRemoveHealthcareProvider) { view in
			view
				.toolbar(content: toolbarContent)
		}
		.navigationBarHidden(false)
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.refreshable {
			viewModel.reduce(.refresh)
		}
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.readSize($contentSize)
	}
	
	/// The view for the header
	/// - Returns: header view
	@ViewBuilder func heading() -> some View {
		
		Text(viewModel.state.heading)
			.typography(.headingExtraLarge)
			.foregroundColor(theme.labels.primary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityAddTraits(.isHeader)
			.accessibilityIdentifier("healthcare_organizations.heading")
			.padding(.top, osVersionChecker.available(version: .iOS(.v17)) ? ViewTraits.Navigation.padding : 0)
	}
	
	/// The view for the sub heading
	/// - Returns: sub heading view
	@ViewBuilder func subHeading() -> some View {
		
		Text(viewModel.state.subheading)
			.typography(.bodyMedium)
			.foregroundColor(theme.labels.primary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityIdentifier("overview.subheading")
	}
	
	/// The view for the categories
	/// - Returns: category view
	@ViewBuilder func categoriesView() -> some View {
		
		List {
			listHeader()
			if viewModel.state.errorState != .none {
				errorCard()
			}
			if viewModel.state.canTitleCollapse {
				favorites()
			}
			
			ForEach(viewModel.state.mainCategories) { mainCategoryView($0) }
		} // List
		.backport.scrollContentBackground(.hidden)
		.listStyle(.insetGrouped)
	}
	
	/// The error card
	/// - Returns: error card
	@ViewBuilder private func errorCard() -> some View {
		
		Section {
			ErrorStateCardView(state: viewModel.state.errorState) {
				viewModel.reduce(.retry)
			}
		}
	}
	
	/// The view for a main category
	/// - Parameter mainCategory: the main category
	/// - Returns: the main category view
	@ViewBuilder private func mainCategoryView(
		_ mainCategory: SharedHealthCategories.MainCategory
	) -> some View {
		
		// We should not show the categories that are marked
		// as favorite in this view. If a main category has all
		// its categories marked, we should hide it from view.
		let filteredCategories = viewModel.state.canTitleCollapse ? mainCategory.categories.filter { !viewModel.state.favorites.contains($0) } : mainCategory.categories
		
		if filteredCategories.isNotEmpty {
			
			Section {
				Text(mainCategory.localized())
					.typography(.headingMedium)
					.foregroundColor(theme.labels.primary)
					.accessibilityAddTraits(.isHeader)
			}
			.listRowBackground(Color.clear)
			.listRowInsets(osVersionChecker.available(version: .iOS(.v17)) ? ViewTraits.List.oldVersionInset : ViewTraits.List.categoryHeaderInset
			)
			
			Section {
				ForEach(filteredCategories) { categoryView($0) }
			}
		}
	}
	
	/// View for a category
	/// - Parameter category: the category
	/// - Returns: category view
	@ViewBuilder private func categoryView(
		_ category: SharedHealthCategories.Category,
		asFavorite: Bool = false
	) -> some View {
		
		if asFavorite {
			
			FavoriteRowView(
				category: category,
				state: viewModel.state.buttonState[category.id] ?? .notAvailable,
				perform: {
					viewModel.reduce(.categorySelected(category))
				}
			)
			
		} else {
			Button {
				viewModel.reduce(.categorySelected(category))
			} label: {
				HealthCategoryRowView(
					category: category,
					state: viewModel.state.buttonState[category.id] ?? .notAvailable
				)
			}
			.padding(.vertical, ViewTraits.List.padding)
			.accessibilityIdentifier(category.id)
			.contentShape(Rectangle())
			
		}
	}
	
	/// The list header
	/// - Returns: list header
	@ViewBuilder private func listHeader() -> some View {
		
		Section {
			VStack(spacing: ViewTraits.List.headerSpacing) {
				if !viewModel.state.canTitleCollapse {
					heading()
				}
				subHeading()
			}
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.headerInset)
	}
	
	/// The favorites section
	/// - Returns: list header
	@ViewBuilder private func favorites() -> some View {
		
		favoritesHeader()
		
		if viewModel.state.favorites.isEmpty {
			favoritesEmptyView()
		} else {
			favoritesGridView()
		}
	}
	
	/// The grid view for the favorite categories
	/// - Returns: the favorite categories in a grid view
	@ViewBuilder private func favoritesGridView() -> some View {
		
		let horizontalPadding = 2 * ViewTraits.General.padding
		let availableWidth = max(0, contentSize.width - horizontalPadding)
		let numberOfColumns = max(2, Int(availableWidth / ViewTraits.Favorites.minWidth))
		let columns = Array(repeating: GridItem(.flexible()), count: numberOfColumns)
		
		LazyVGrid(columns: columns, spacing: ViewTraits.Favorites.gridSpacing) {
			ForEach(viewModel.state.favorites) {
				categoryView($0, asFavorite: true)
					.cornerRadius(ViewTraits.Favorites.cornerRadius)
			}
		}
		.clipShape(Rectangle())
		.listRowInsets(ViewTraits.List.zeroInset)
		.listRowBackground(Color.clear)
	}
	
	/// The heading for the favorite section
	/// - Returns: view for the favorite header
	@ViewBuilder private func favoritesHeader() -> some View {
		Section {
			HStack {
				Text("overview.favorites.heading")
					.typography(.headingMedium)
					.foregroundColor(theme.labels.primary)
					.accessibilityAddTraits(.isHeader)
				
				Spacer()
				
				favoritesHeaderButton()
			}
		}
		.listRowInsets(
			viewModel.state.errorState == .none ?
			ViewTraits.List.favoritesHeaderInset : ViewTraits.List.favoritesHeaderErrorInset
		)
		.listRowBackground(Color.clear)
	}
	
	/// The action button for the favorites
	/// - Returns: action button
	@ViewBuilder private func favoritesHeaderButton() -> some View {
		if viewModel.state.favorites.isEmpty {
			Button("overview.favorites.empty.action") {
				viewModel.reduce(.showFavorites)
			}.buttonStyle(SectionButtonStyle())
				.accessibilityIdentifier("overview.favorites.empty.action")
		} else {
			Button("overview.favorites.add") {
				viewModel.reduce(.showFavorites)
			}.buttonStyle(SectionButtonStyle())
				.accessibilityIdentifier("overview.favorites.add")
		}
	}
	
	/// The empty state when the user has no favorite categories
	/// - Returns: view for the empty state
	@ViewBuilder private func favoritesEmptyView() -> some View {
		
		Section {
			addFavoriteCategoriesButton()
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.Favorites.rowInset)
	}
	
	/// The dashed button to add favorite categories
	/// - Returns: view for the add favorites button
	@ViewBuilder private func addFavoriteCategoriesButton() -> some View {
		
		Text("overview.favorites.empty.heading")
			.typography(.bodyMedium)
			.foregroundStyle(theme.labels.primary)
			.padding(ViewTraits.General.padding)
			.frame(maxWidth: .infinity, alignment: .leading)
			.overlay(
				RoundedRectangle(cornerRadius: ViewTraits.Favorites.cornerRadius)
					.inset(by: ViewTraits.Favorites.inset)
					.stroke(
						theme.separators.primary,
						style: ViewTraits.Favorites.style
					)
			)
	}
	
	/// Create the empty state view
	/// - Returns: View when the user has no stored healthcare organizations
	@ViewBuilder private func noHealthcareOrganizationView() -> some View {
		
		ScrollViewWithFixedBottom {
			
			ImageContentView(
				icon: Image(ImageResource.Woman.womanWithPhone),
				heading: "common.no_organizations_heading",
				subHeading: "common.no_organizations_subheading",
				subHeadingForegroundColor: theme.labels.primary
			)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.top, ViewTraits.NoResults.top)
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			
			CallToActionButton(
				featureFlagManager.isAutomaticLocalizationEnabled ? "common.search_organizations" : "common.add_organizations",
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
	
	/// Get the toolbar content (favorites)
	/// - Returns: the toolbar content
	@ToolbarContentBuilder private func toolbarContent() -> some ToolbarContent {
		ToolbarItemGroup(
			placement: .topBarTrailing,
			content: {
				Menu {
					if viewModel.state.showRemoveHealthcareProvider {
						menuRemoveHealthcareOrganizationOption()
					}
				} label: {
					moreIcon()
				}
				.buttonStyle(ToolbarButtonStyle())
				.accessibilityLabel("overview.menu")
				.accessibilityIdentifier("overview.menu")
			}
		)
	}
	
	@ViewBuilder func moreIcon() -> some View {
		
		if osVersionChecker.available(version: .iOS(.v26)) {
			Image(ImageResource.Icon.more26)
				.foregroundStyle(theme.labels.primary)
		} else {
			Image(ImageResource.Icon.more)
		}
	}
	
	/// The remove healthcare organization option
	/// - Returns: view
	@ViewBuilder func menuRemoveHealthcareOrganizationOption() -> some View {
		
		Button(role: .destructive) {
			viewModel.reduce(.removeHealthcareOrganization)
		} label: {
			Label("organizations.remove_organization", systemImage: "trash")
				.tint(theme.states.critical)
		}
		.accessibilityIdentifier("organizations.remove_organization")
	}
}
// swiftlint: enable type_body_length

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthCategoriesView(
			viewModel: HealthCategoriesViewModel(
				coordinator: nil,
				mode: .single(PreviewContent.healthcareOrganization)
			)
		)
	}
}
