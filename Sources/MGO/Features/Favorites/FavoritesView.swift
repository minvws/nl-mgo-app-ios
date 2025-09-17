/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOUI
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
	
	/// The state
	@Published var state: State
	
	/// A list of all the actions this viewModel can handle
	enum Action {
//		case closeButtonPressed
//		case saveButtonPressed
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
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: FavoritesViewModel.Action) {
		
		switch action {
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
			static let size: CGFloat = 32
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
		
		VStack {
			
			categoriesView()
				.backport.listSectionSpacing(ViewTraits.List.spacing)
				.backport.contentMargins(0)
			
			Spacer()
		}
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.environment(\.editMode, $editMode)
	}
	
	/// The view for the categories
	/// - Returns: category view
	@ViewBuilder func categoriesView() -> some View {
		
		List {
			favoritesView()
			
			ForEach(viewModel.state.mainCategories) { mainCategoryView($0) }
			
		} // List
		.backport.scrollContentBackground(.hidden)
		.listStyle(.insetGrouped)
	}
	
	@ViewBuilder private func favoritesView() -> some View {
		
		sectionHeader(String(localized: "edit_overview.favorites.heading"))
		
		Section {
			if viewModel.state.favorites.isEmpty {
				
				Text("edit_overview.favorites.empty")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentSecondary)
			} else {
				
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
					editMode = viewModel.state.favorites.count > 1 ? .active : .inactive
				}
			}
		}
	}
	
	/// The header for a section
	/// - Parameter heading: the section heading text
	/// - Returns: view for the section header
	@ViewBuilder private func sectionHeader(_ heading: String) -> some View {
		
		Section {
			Text(heading)
				.rijksoverheidStyle(font: .bold, style: .headline)
				.foregroundColor(theme.contentPrimary)
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
			
			sectionHeader(String(localized: String.LocalizationValue(stringLiteral: mainCategory.heading)))
			
			ForEach(filteredCategories) { category in
				
				categoryView(
					category,
					icon: Image(ImageResource.Icon.add),
					action: { viewModel.reduce(.addButtonPressed(category)) }
				)
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
			.buttonStyle(PlainButtonStyle())
			
			category.getIcon(theme)
				.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size)
				.padding(.trailing, ViewTraits.Icon.padding)
			
			Text(String(localized: String.LocalizationValue(stringLiteral: category.heading)))
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundColor(theme.contentPrimary)
			
		}
		.frame( maxWidth: .infinity, alignment: .leading)
		.accessibilityIdentifier(category.id)
		.listRowInsets(ViewTraits.List.rowInset)
		.frame(minHeight: ViewTraits.List.minHeight)
	}
}
