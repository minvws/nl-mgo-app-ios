/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct HealthCategoryView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthCategoryViewModel
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let inset: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let oldVersionInset: EdgeInsets = EdgeInsets(top: 24, leading: 0, bottom: 2, trailing: 16)
			static let headerInset: EdgeInsets = EdgeInsets(top: 24, leading: 16, bottom: 2, trailing: 16)
		}
		enum FullScreen {
			static let textSpacing: CGFloat = 8
			static let iconSize: CGFloat = 50
		}
	}
	
	var body: some View {
		
		Group {
			
			switch viewModel.state {
				case .loading:
					fullScreenLoadingScreen
				case let .list(items, errorState):
					if items.flatMap({ $0.rows }).isEmpty {
						fullScreenEmptyScreen(errorState)
					} else {
						listOverview(
							list: items,
							errorState: errorState
						)
					}
			}
		}
		.backport.scrollContentBackground(.hidden)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton(LocalizedStringKey(String(localized: viewModel.translations.backButtonTitle))) {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationTitle(String(localized: viewModel.translations.heading))
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
	
	/// The full screen loading state
	@ViewBuilder private var fullScreenLoadingScreen: some View {
		
		VStack {
			Spacer()
			ErrorStateCardView(state: .loading)
			Spacer()
		}
	}
	
	/// The full screen empty screens
	/// - Parameter errorState: the error state
	/// - Returns: the full screen empty screen for the error state
	@ViewBuilder private func fullScreenEmptyScreen(
		_ errorState: HealthCategoriesErrorState
	) -> some View {
		
		switch errorState {
			case .none:
				fullScreenPage(
					image: viewModel.category.getIcon(),
					heading: String(localized: "health_category.empty.heading"),
					subHeading: String(localized: "health_category.empty.subheading"),
					actionTitle: "health_category.empty.action"
				) {
					viewModel.reduce(.backButtonPressed)
				}
				
			case .loading:
				// Should not happen
				fullScreenLoadingScreen
				
			case .error(let heading, let subHeading):
				
				fullScreenPage(
					image: Image(ImageResource.Icon.syncProblem),
					heading: heading,
					subHeading: subHeading,
					actionTitle: "common.try_again"
				) {
					viewModel.reduce(.retry)
				}
		}
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverview(
		list: [HealthCategoryBlock],
		errorState: HealthCategoriesErrorState
	) -> some View {
		
		List {
			
			switch errorState {
				case .none:
					EmptyView()
				case .loading:
					Section {
						ErrorStateCardView(state: .loading)
					}
				case .error(let heading, let subHeading):
					Section {
						ErrorStateCardView(state: .error(heading: heading, subHeading: subHeading)) {
							viewModel.reduce(.retry)
						}
					}
			}
			
			listOverviewBlocks(list: list)
				.backport.listSectionSpacing(8)
				.backport.contentMargins(0)
				.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		}
		.toolbar { pdfExportToolbarContent }
		.inspectableFullScreenCover(isPresented: $viewModel.showExportAlert) {
			ConfirmationAlertCoverView(
				heading: String(localized: "export_pdf.dialog.heading"),
				subheading: String(localized: "export_pdf.dialog.subheading"),
				actionText: String(localized: "export_pdf.dialog.create_document"),
				cancelText: String(localized: "common.cancel"),
				isPresented: $viewModel.showExportAlert,
				onConfirm: { viewModel.reduce(.exportHealthData) }
			)
			.clearFullScreenCoverBackground()
			.interactiveDismissDisabled()
		}
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverviewBlocks(list: [HealthCategoryBlock]) -> some View {
		
		ForEach(Array(list.enumerated()), id: \.offset) { subCategoryIndex, subCategory in
			
			if subCategory.rows.isNotEmpty {
				blockView(
					showHeading: list.filter { $0.rows.isNotEmpty }.count != 1,
					subCategory: subCategory,
					subCategoryIndex: subCategoryIndex
				)
			}
		}
	}
	
	/// Block view for a subcategory
	/// - Parameters:
	///   - list: the list of categories
	///   - subCategory: a sub category
	///   - subCategoryIndex: the index of the subcategory
	/// - Returns: view
	@ViewBuilder private func blockView(
		showHeading: Bool,
		subCategory: HealthCategoryBlock,
		subCategoryIndex: Int
	) -> some View {
		
		if showHeading {
			
			let inset = osVersionChecker
				.available(
					version: .iOS(.v26)
				) ? ViewTraits.List.headerInset : ViewTraits.List.oldVersionInset
			
			Section {
				Text(subCategory.heading)
					.typography(.headingMedium)
					.foregroundColor(theme.labels.primary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
			}
			.listRowBackground(Color.clear)
			.when(subCategoryIndex == 0) { view in
				view
					.listRowInsets(
						EdgeInsets(
							top: 8,
							leading: inset.leading,
							bottom: inset.bottom,
							trailing: inset.trailing
						)
					)
			}
			.when(subCategoryIndex != 0) { view in
				view
					.listRowInsets(inset)
			}
		}
		
		ForEach(Array(subCategory.rows.enumerated()), id: \.offset) { index, element in
			Section {
				HealthCategoryBlockRowView(
					element: element,
					accessibilityIdentifier: "category_element_\(subCategoryIndex)_\(index)"
				)
			}
		}
	}
	
	/// The toolbar content (export to pdf)
	private var pdfExportToolbarContent: some ToolbarContent {
		PDFExportToolbarContent {
			viewModel.reduce(.showExportAlert)
		}
	}

	/// Full Screen page
	/// - Parameters:
	///   - image: the image to display
	///   - heading: the heading of the page
	///   - subHeading: the sub heading of the page
	///   - actionTitle: the title of the action
	///   - action: the action
	/// - Returns: Full Screen page
	@ViewBuilder private func fullScreenPage(
		image: Image,
		heading: String,
		subHeading: String,
		actionTitle: LocalizedStringKey,
		action: (() -> Void)?
	) -> some View {
		
		VStack(alignment: .center, spacing: ViewTraits.FullScreen.textSpacing, content: {
			Spacer()
			
			HStack {
				Spacer()
				image
					.resizable()
					.frame(
						width: ViewTraits.FullScreen.iconSize,
						height: ViewTraits.FullScreen.iconSize,
						alignment: .center
					)
					.foregroundStyle(theme.symbols.primary)
				Spacer()
			}
			.padding(.bottom, ViewTraits.General.padding)
			
			Text(heading)
				.typography(.headingSmall)
				.foregroundStyle(theme.labels.primary)
				.accessibilityAddTraits(.isHeader)
			
			Text(subHeading)
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.secondary)
				.multilineTextAlignment(.center)
			
			Spacer()
			
			CallToActionButton(
				actionTitle,
				style: .solid(
					rounded: osVersionChecker.available(version: .iOS(.v26)),
					narrow: false
				)
			) {
				action?()
			}
			.padding(.horizontal, ViewTraits.General.padding)
			.padding(.bottom, ViewTraits.General.padding)
		})
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthCategoryView(
			viewModel: HealthCategoryViewModel(
				coordinator: nil,
				category: PreviewContent.category,
				organization: PreviewContent.healthcareOrganization,
				translations: HealthCategoryViewTranslations(
					heading: "hc_medication.heading",
					search: "hc_medication.search",
					noSearchResults: "hc_medication.no_search_results",
					backButtonTitle: "hc_medication.heading_detail"
				)
			)
		)
	}
}
