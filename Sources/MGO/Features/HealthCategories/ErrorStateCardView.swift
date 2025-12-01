/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOUI
import MGOFoundation

struct ErrorStateCardView: View {
	
	/// The state of the view
	var state: HealthCategoriesErrorState
	
	/// The try again action
	var action: (() -> Void)?

	/// The Theme
	@Environment(\.theme) var theme
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Icon {
			static let size: CGFloat = 24
		}
		enum Loading {
			static let spacing: CGFloat = 8
			static let size: CGFloat = 30
		}
		enum Section {
			static let minHeight: CGFloat = 124
		}
	}
	
	var body: some View {
		
		switch state {
			case .none:
				EmptyView()
			case .loading:
				loadingState()
			case .error(let heading, let subHeading):
				errorState(heading: heading, subHeading: subHeading)
		}
	}
	
	/// The view for the loading state
	/// - Returns: the loading state view
	@ViewBuilder private func loadingState() -> some View {
		HStack {
			Spacer()
			
			VStack(alignment: .center, spacing: ViewTraits.Loading.spacing) {
				ProgressView()
					.progressViewStyle(.circular)
					.scaleEffect(ViewTraits.Loading.size / 22)
					.frame(
						width: ViewTraits.Loading.size,
						height: ViewTraits.Loading.size
					)
					.tint(theme.symbols.secondary)
				Text("overview.errorstate.loading")
					.typography(.bodyMedium)
					.foregroundStyle(theme.labels.secondary)
			}
			.frame(minHeight: ViewTraits.Section.minHeight)
			
			Spacer()
		}
	}
	
	/// The view for the error state
	/// - Parameters:
	///   - heading: the title for the card
	///   - subHeading: the sub title for the card
	/// - Returns: the card in error state
	@ViewBuilder private func errorState(heading: String, subHeading: String) -> some View {
		VStack(alignment: .leading, spacing: 16, content: {
			HStack(alignment: .top, spacing: 8, content: {
				
				Image(ImageResource.Icon.syncProblem)
					.foregroundStyle(theme.symbols.primary)
					.frame(
						width: ViewTraits.Icon.size,
						height: ViewTraits.Icon.size
					)
				
				VStack(alignment: .leading, spacing: 4) {
					Text(heading)
						.typography(.bodyMedium, isBold: true)
						.foregroundStyle(theme.labels.primary)
					Text(subHeading)
						.typography(.bodyMedium)
						.foregroundStyle(theme.labels.secondary)
					
				}
			})
			
			CallToActionButton(
				"common.try_again",
				style: .solid(
					rounded: osVersionChecker.available(version: .iOS(.v26)),
					narrow: true
				)
			) {
				action?()
			}
		})
		.frame(minHeight: ViewTraits.Section.minHeight)
	}
}
