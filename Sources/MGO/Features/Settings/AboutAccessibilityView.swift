/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AboutAccessibilityViewModel: BaseViewModel {
	// No additional implementation
}

struct AboutAccessibilityView: View {
	
	/// The View Model
	@StateObject var viewModel: AboutAccessibilityViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 24
		}
		enum General {
			static let padding: CGFloat = 16
			static let inset: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
		}
	}
	
	var body: some View {
		
		List {
			Section {
				
				subheading()
			}
			.listRowInsets(ViewTraits.General.inset)
			.padding(ViewTraits.General.padding)
		}
		.backport.scrollContentBackground(.hidden)
		.backport.contentMargins(ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationTitle("settings.accessibility.heading")
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgrounds.primary.ignoresSafeArea())
	}
	
	/// Get the sub heading
	/// - Returns: the sub heading view
	@ViewBuilder private func subheading() -> some View {
		
		Text("settings.accessibility.subheading")
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundStyle(theme.labels.primary)
			.accessibilityIdentifier("settings.accessibility.subheading")
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AboutAccessibilityView(viewModel: AboutAccessibilityViewModel(coordinator: nil))
	}
}
