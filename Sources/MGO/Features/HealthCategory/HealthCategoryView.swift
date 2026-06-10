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
			static let oldCornerRadius: CGFloat = 12
			static let cornerRadius: CGFloat = 26
		}
		enum FullScreen {
			static let textSpacing: CGFloat = 8
			static let iconSize: CGFloat = 50
		}
		enum PartialError {
			static let bottom: CGFloat = 12
		}
		enum SubHeading {
			static let top: CGFloat = 10
			static let bottom: CGFloat = 12
			static let spacing: CGFloat = 32
		}
		enum List {
			static let bottom: CGFloat = 32
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
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationTitle(LocalizedStringKey(viewModel.category.heading))
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
		
		ScrollView {
			VStack(spacing: 0) {
				
				descriptionBlock(list: list)
				
				errorBanner(errorState)
				
				listOverviewBlocks(list: list)
			}
			.padding(.bottom, ViewTraits.List.bottom)
		}
		.toolbar { pdfExportToolbarContent }
		.confirmationAlert(
			heading: String(localized: "export_pdf.dialog.heading"),
			subheading: String(localized: "export_pdf.dialog.subheading"),
			actionText: String(localized: "export_pdf.dialog.create_document"),
			cancelText: String(localized: "common.cancel"),
			isPresented: $viewModel.showExportAlert,
			onConfirm: { viewModel.reduce(.exportHealthData) }
		)
	}
	
	/// Card-chrome wrapper around `ErrorStateCardView` for in-stack usage
	@ViewBuilder private func errorBanner(
		_ errorState: HealthCategoriesErrorState
	) -> some View {
		
		if case .none = errorState {
			EmptyView()
		} else {
			errorBannerCard(errorState)
				.padding(.horizontal, ViewTraits.General.padding)
				.padding(.vertical, ViewTraits.PartialError.bottom)
				.background(theme.backgrounds.secondary)
				.clipShape(
					RoundedRectangle(
						cornerRadius: osVersionChecker
							.available(version: .iOS(.v26))
						? ViewTraits.General.cornerRadius
						: ViewTraits.General.oldCornerRadius
					)
				)
				.padding(.horizontal, ViewTraits.General.padding)
		}
	}
	
	/// Builds the `ErrorStateCardView` for the given non-`.none` error state
	@ViewBuilder private func errorBannerCard(
		_ errorState: HealthCategoriesErrorState
	) -> some View {
		
		switch errorState {
			case .loading:
				ErrorStateCardView(state: .loading)
			case .error(let heading, let subHeading):
				ErrorStateCardView(
					state: .error(
						heading: heading,
						subHeading: subHeading
					)
				) {
					viewModel.reduce(.retry)
				}
			case .none:
				EmptyView()
		}
	}
	
	/// The description of this category
	@ViewBuilder private func descriptionBlock(list: [HealthCategoryBlock]) -> some View {
		
		let resultCount = list.flatMap(\.rows).count
		VStack(spacing: ViewTraits.SubHeading.spacing) {
			
#warning("Rool, 05/05/2026: Disabled until the description key has been added to the config")
//			Text(LocalizedStringKey(viewModel.category.subheading))
//				.typography(.bodyMedium)
//				.foregroundStyle(theme.labels.primary)
//				.frame(maxWidth: .infinity, alignment: .topLeading)
			
			Text(String(localized: "health_category.num_results \(resultCount)"))
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.secondary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
		}
		.padding(.top, ViewTraits.SubHeading.top)
		.padding(.bottom, ViewTraits.SubHeading.bottom)
		.padding(.horizontal, ViewTraits.General.padding)
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverviewBlocks(list: [HealthCategoryBlock]) -> some View {
		
		let visible = list.filter { $0.rows.isNotEmpty }
		let lastTimelineIndex = visible.lastIndex { !$0.isUnknownDate } ?? -1
		let useTimeline = viewModel.type == .timeline
		ForEach(Array(visible.enumerated()), id: \.offset) { index, block in
			HealthCategoryBlockView(
				block: block,
				blockIndex: index,
				isLast: index == lastTimelineIndex,
				useTimeline: useTimeline,
				showHeading: useTimeline || visible.count != 1
			)
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
			.padding(.bottom, ViewTraits.General.padding)
		})
		.padding(.horizontal, ViewTraits.General.padding)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthCategoryView(
			viewModel: HealthCategoryViewModel(
				coordinator: nil,
				category: PreviewContent.category,
				organization: PreviewContent.healthcareOrganization
			)
		)
	}
}
