/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOUI
import MGOFoundation
import MGODebug

class FavoritesViewModel: ObservableObject {
	
	struct State {
		
		/// All the categories
		var mainCategories: [SharedHealthCategories.MainCategory]
		
		/// The favorite categories
		var favorites: [SharedHealthCategories.Category]
	}
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// Dependency injectable Favorites store
	@Injected(\.favoritesRepository) private var favoritesRepository
	
	/// The state
	@Published var state: State
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case closeButtonPressed
		case saveButtonPressed
		case addButtonPressed(SharedHealthCategories.Category)
		case removeButtonPressed(SharedHealthCategories.Category)
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	@MainActor init(coordinator: (any Coordinator)? = nil) {
		
		self.coordinator = coordinator
		
		let mainCategories = try? SharedHealthCategories().mainCategories
		
		self.state = State(
			mainCategories: mainCategories ?? [],
			favorites: []
		)
		prepareFavorites()
	}
	
	/// Maybe the shared categories have been altered by an update,
	/// and the stored favorite is no longer a category.
	@MainActor private func prepareFavorites() {
		
		let shared = try? SharedHealthCategories()
		self.state.favorites = favoritesRepository.items.filter { favorite in
			// Only add those favorites that are still a valid category
			// based upon id, as there might be new profiled for a category and
			// or new subcategories.
			for category in shared?.categories() ?? [] where category.id == favorite.id {
				return true
			}
			return false
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: FavoritesViewModel.Action) {
		
		switch action {
			case .closeButtonPressed:
				coordinator?.handle(.closeSheet)
			
			case .saveButtonPressed:
				try? favoritesRepository.set(state.favorites)
				coordinator?.handle(.closeSheet)
			
			case let .addButtonPressed(category):
				withAnimation {
					state.favorites.append(category)
				}
				
			case let .removeButtonPressed(category):
				withAnimation {
					state.favorites = state.favorites.filter { $0.id != category.id }
				}
		}
	}
}

/// The view to select favorite categories
struct FavoritesView: View {
	
	/// The View Model
	@StateObject var viewModel: FavoritesViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The edit mode (used for reordering the favorites)
	@State var editMode: EditMode = .active
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Icon {
			static let padding: CGFloat = 16
		}
		enum Action {
			static let size: CGFloat = 22
			static let padding: CGFloat = 16
		}
		enum List {
			static let padding: CGFloat = 16
			static let rowInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let headerInset = EdgeInsets(top: 32, leading: 0, bottom: 12, trailing: 0)
			static let spacing: CGFloat = 4
			static let minHeight: CGFloat = 52
		}
	}
	
	var body: some View {
		
		List {
			favoritesView()
			
			ForEach(viewModel.state.mainCategories, id: \.id) { mainCategoryView($0) }
			
		} // List
		.backport.scrollContentBackground(.hidden)
		.listStyle(.insetGrouped)
		.backport.listSectionSpacing(ViewTraits.List.spacing)
		.backport.contentMargins(0)
		.interactiveDismissDisabled(true) // Disable dragging by the user for this sheet
		.navigationTitle("edit_overview.heading")
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.environment(\.editMode, $editMode)
		.toolbar(content: leadingToolbarContent)
		.toolbar(content: trailingToolbarContent)
	}
	
	/// Get the leading toolbar content
	/// - Returns: the toolbar content
	@ToolbarContentBuilder private func leadingToolbarContent() -> some ToolbarContent {
		
		let cancelKey: LocalizedStringKey = "common.cancel"
		
		ToolbarItem(placement: .cancellationAction) {
			if #available(iOS 26.0, *) {
				Button(role: .close) {
					viewModel.reduce(.closeButtonPressed)
				}
				.accessibilityLabel(cancelKey)
				
			} else {
				Button {
					viewModel.reduce(.closeButtonPressed)
				} label: {
					Text(cancelKey)
						.typography(.bodyMedium)
				}
				.accessibilityLabel(cancelKey)
			}
		}
	}
	
	/// Get the trailing toolbar content
	/// - Returns: the toolbar content
	@ToolbarContentBuilder private func trailingToolbarContent() -> some ToolbarContent {
		
		let saveKey: LocalizedStringKey = "edit_overview.save"
		
		ToolbarItem(placement: .confirmationAction) {
			if #available(iOS 26.0, *) {
				Button(role: .confirm) {
					viewModel.reduce(.saveButtonPressed)
				}
				.accessibilityLabel(saveKey)
			} else {
				Button {
					viewModel.reduce(.saveButtonPressed)
				} label: {
					Text(saveKey)
						.typography(.bodyMedium, isBold: true)
				}
				.accessibilityLabel(saveKey)
			}
		}
	}
	
	/// The view for the favorites
	/// - Returns: favorites view
	@ViewBuilder private func favoritesView() -> some View {
		
		sectionHeader(String(localized: "edit_overview.favorites.heading"))
		
		Section {
			if viewModel.state.favorites.isEmpty {
				
				Text("edit_overview.favorites.empty")
					.typography(.bodyMedium)
					.foregroundStyle(theme.labels.secondary)
			} else {
				
				favoritesListView()
			}
		}
	}
	
	/// The list view for all the favorites
	/// - Returns: the favorites list view
	@ViewBuilder private func favoritesListView() -> some View {
		
		ForEach(viewModel.state.favorites, id: \.id) { category in
			categoryView(
				category,
				icon: Image(ImageResource.Icon.remove),
				action: { viewModel.reduce(.removeButtonPressed(category)) }
			)
		}
		.onMove { indices, newOffset in
			withAnimation {
				viewModel.state.favorites.move(fromOffsets: indices, toOffset: newOffset)
			}
		}
		.onChange(of: viewModel.state.favorites) { favorites in
			editMode = favorites.count > 1 ? .active : .inactive
		}
	}
	
	/// The header for a section
	/// - Parameter heading: the section heading text
	/// - Returns: view for the section header
	@ViewBuilder private func sectionHeader(_ heading: String) -> some View {
		
		Section {
			Text(heading)
				.typography(.headingMedium)
				.foregroundColor(theme.labels.primary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.headerInset)
	}
	
	/// The view for a main category
	/// - Parameter mainCategory: the main category
	/// - Returns: the main category view
	@ViewBuilder private func mainCategoryView(
		_ mainCategory: SharedHealthCategories.MainCategory
	) -> some View {
		
		let filteredCategories = mainCategory.categories.filter { !viewModel.state.favorites.contains($0) }
		
		if filteredCategories.isNotEmpty {
			
			sectionHeader(mainCategory.localized())
			
			Section {
				ForEach(filteredCategories) { category in
					categoryView(
						category,
						icon: Image(ImageResource.Icon.add),
						action: { viewModel.reduce(.addButtonPressed(category)) }
					)
				}
			}
		}
	}
	
	/// View for a category
	/// - Parameter category: the category
	/// - Returns: category view
	@ViewBuilder private func categoryView(
		_ category: SharedHealthCategories.Category,
		icon: Image,
		action: @escaping () -> Void
		
	) -> some View {
		
		HStack(alignment: .center, spacing: 0) {
			Button {
				editMode = .inactive
				action()
			} label: {
				icon
					.resizable()
					.frame(width: ViewTraits.Action.size, height: ViewTraits.Action.size)
					.padding(ViewTraits.Action.padding)
			}
			// Any style but default makes only the button tappable instead
			// of the whole view, which renders the drag and drop unusable.
			.buttonStyle(PlainButtonStyle())
			
			HealthCategoryIconView(category: category, state: nil)
				.padding(.trailing, ViewTraits.Icon.padding)
			
			Text(category.localizedHeading())
				.typography(.bodyMedium)
				.foregroundColor(theme.labels.primary)
			
		}
		.frame( maxWidth: .infinity, alignment: .leading)
		.accessibilityIdentifier(category.id)
		.listRowInsets(ViewTraits.List.rowInset)
		.frame(minHeight: ViewTraits.List.minHeight)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		FavoritesView(
			viewModel: FavoritesViewModel(
				coordinator: nil
			)
		)
	}
}
