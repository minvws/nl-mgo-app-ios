/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

class VersionViewModel: BaseViewModel {
	
	struct State {
		struct HcimVersion {
			let version: String?
			let date: String?
			let git: String?
		}
		
		struct SharedVersion {
			let version: String?
			let date: String?
			let git: String?
		}
		
		let hcim: HcimVersion
		let shared: SharedVersion
	}
	
	@Published var state: State?
	
	/// Dependency Injectable Resource Repository
	@Injected(\.resourceRepository) private var resourceRepository
	
	@MainActor override init(coordinator: (any Coordinator)? = nil) {
		super.init(coordinator: coordinator)
		setState()
	}
	
	@MainActor func setState() {
		
		do {
			let hcimVersion = try HCIMParser().getVersion()
			let sharedVersion = try resourceRepository.getVersion()
			
			state = State(
				hcim: State.HcimVersion(
					version: hcimVersion.version,
					date: hcimVersion.created,
					git: String(hcimVersion.gitRef.prefix(7))
				),
				shared: State.SharedVersion(
					version: sharedVersion.version,
					date: sharedVersion.created,
					git: String(sharedVersion.gitRef.prefix(7))
				)
			)
		} catch {
			logError("No version found: \(error)")
		}
	}
}

struct VersionView: View {
	
	/// The View Model
	@StateObject var viewModel: VersionViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Dependency Injectable Patient Friendly Terms Repository
	@Injected(\.patientFriendyTermsRepository) private var patientFriendyTermsRepository
	
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
			static let spacing: CGFloat = 4
			static let sectionSpacing: CGFloat = 16
		}
	}
	
	var body: some View {
		
		List {
			hcimPackage()
			sharedConfig()
			patientFriendlyTerms()
		}
		.backport
		.listSectionSpacing(osVersionChecker.available(version: .iOS(.v26)) ? 0 : ViewTraits.List.sectionSpacing)
		.backport.scrollContentBackground(.hidden)
		.backport.contentMargins(ViewTraits.Navigation.padding)
		.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("settings.about_this_app.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("settings.version.heading")
		.background(theme.backgrounds.primary.ignoresSafeArea())
	}
	
	/// The HCIM Package
	/// - Returns: the HCIM Package
	@ViewBuilder private func hcimPackage() -> some View {
		
		sectionHeading("HCIM Package", firstSection: true)
		
		Section {
			row(
				heading: "Versie",
				value: viewModel.state?.hcim.version ?? String(localized: "common.unknown")
			)
			row(
				heading: "Datum",
				value: viewModel.state?.hcim.date ?? String(localized: "common.unknown")
			)
			row(
				heading: "Git-ref",
				value: viewModel.state?.hcim.git ?? String(localized: "common.unknown")
			)
		}
	}
	
	/// The Shared Config
	/// - Returns: the Shared Config
	@ViewBuilder private func sharedConfig() -> some View {
		
		sectionHeading("Shared Config")
		
		Section {
			row(
				heading: "Versie",
				value: viewModel.state?.shared.version ?? String(localized: "common.unknown")
			)
			row(
				heading: "Datum",
				value: viewModel.state?.shared.date ?? String(localized: "common.unknown")
			)
			row(
				heading: "Git-ref",
				value: viewModel.state?.shared.git ?? String(localized: "common.unknown")
			)
		}
	}
	
	/// The PFT Section
	/// - Returns: PFT Section
	@ViewBuilder private func patientFriendlyTerms() -> some View {
		
		sectionHeading("Patiënt Vriendelijke Term")
		
		Section {
			row(
				heading: "ETag",
				value: patientFriendyTermsRepository.eTag ?? String(localized: "common.unknown")
			)
		}
	}
	
	/// Create a section heading
	/// - Parameter heading: the heading to display
	/// - Returns: the section heading
	@ViewBuilder private func sectionHeading(_ heading: LocalizedStringKey, firstSection: Bool = false) -> some View {
		
		Section {
			Text(heading)
				.typography(.headingMedium)
				.foregroundStyle(theme.labels.primary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
		}
		.listRowBackground(Color.clear)
		.listRowInsets(firstSection ? ViewTraits.List.alternativeInset : ViewTraits.List.headerInset)
	}
	
	/// get the view for a row of heading and value
	/// - Parameters:
	///   - heading: the heading
	///   - value: the value
	/// - Returns: a row of heading and value
	@ViewBuilder private func row(heading: LocalizedStringKey, value: String) -> some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.List.spacing) {
			Text(heading)
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.secondary)
				.accessibilityAddTraits(.isHeader)
			
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
