/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

class VersionViewModel: BaseViewModel {
	
}

struct VersionView: View {
	
	/// The View Model
	@StateObject var viewModel: VersionViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 24
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let headerInset: EdgeInsets = EdgeInsets(top: 32, leading: 0, bottom: 12, trailing: 0)
			static let alternativeInset = EdgeInsets(top: 8, leading: 0, bottom: 12, trailing: 0)
		}
	}
	
	var body: some View {
		
		List {
			hcimPackage()
			sharedConfig()
			patientFriendlyTerms()
		}
		.backport.listSectionSpacing(osVersionChecker.available(version: .iOS(.v26)) ? 0 : 16)
		.backport.scrollContentBackground(.hidden)
		.backport.contentMargins(ViewTraits.Navigation.padding)
		.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("settings.about_this_app.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Versie")
		.background(theme.backgrounds.primary.ignoresSafeArea())
	}
	
	@ViewBuilder private func hcimPackage() -> some View {
		
		Section {
			// A schema group has a section label
			Text("HCIM Package")
				.typography(.headingMedium)
				.foregroundStyle(theme.labels.primary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.alternativeInset)
		
		Section {
			row(heading: "Versie", value: "1.4.2")
			row(heading: "Datum", value: "8 september 2025")
			row(heading: "Git-ref", value: "abc123edf")
		}
	}
	
	@ViewBuilder private func sharedConfig() -> some View {
		
		Section {
			Text("Shared Config")
				.typography(.headingMedium)
				.foregroundStyle(theme.labels.primary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.headerInset)
		
		Section {
			row(heading: "Versie", value: "2.0.7")
			row(heading: "Datum", value: "9 september 2025")
			row(heading: "Git-ref", value: "98y7sadf987")
		}
	}
	
	@ViewBuilder private func patientFriendlyTerms() -> some View {
		
		Section {
			Text("Patient Vriendelijke Term")
				.typography(.headingMedium)
				.foregroundStyle(theme.labels.primary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.headerInset)
		
		Section {
			row(heading: "ETag", value: "asdfasdf")
		}
	}
	
	@ViewBuilder private func row(heading: String, value: String) -> some View {
		
		VStack(alignment: .leading, spacing: 4) {
			Text(heading)
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.secondary)
			Text(value)
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.primary)
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		VersionView(viewModel: VersionViewModel(coordinator: nil))
	}
}
