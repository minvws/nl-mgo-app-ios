/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AboutOpenSourceLibrariesViewModel: BaseViewModel {
	
	/// An open source library
	struct Library: Equatable, Identifiable {
		
		/// Identifier
		let id = UUID()
		
		/// The name of the library
		var name: String
				
		/// The url of the libraries license
		var urlString: String
	}
	
	/// The open source libraries
	@Published var libraries: [AboutOpenSourceLibrariesViewModel.Library] = []
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case openUrl(String)
	}
	
	/// Create the about open source ViewModel
	/// - Parameter coordinator: the app coordinator
	override init(coordinator: (any Coordinator)? = nil) {
		super.init(coordinator: coordinator)
		
		libraries = [
			Library(
				name: "DeviceKit (MIT)",
				urlString: "https://github.com/devicekit/DeviceKit?tab=MIT-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "Figlet (Apache 2.0)",
				urlString: "https://github.com/apple/example-package-figlet?tab=Apache-2.0-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "iOS Security Suite (BSD 2)",
				urlString: "https://github.com/securing/IOSSecuritySuite/tree/1.9.11?tab=License-1-ov-file" // NOSONAR
			),
			Library(
				name: "Nimble (Apache 2.0)",
				urlString: "https://github.com/Quick/Nimble?tab=Apache-2.0-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "OHHTTPStubs (MIT)",
				urlString: "https://github.com/AliSoftware/OHHTTPStubs?tab=MIT-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "RDO Modules - Logging (EUPL 1.2)",
				urlString: "https://github.com/minvws/nl-rdo-app-ios-modules?tab=EUPL-1.2-1-ov-file" // NOSONAR
			),
			Library(
				name: "📸 SnapshotTesting (MIT)",
				urlString: "https://github.com/pointfreeco/swift-snapshot-testing?tab=MIT-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "Swift Argument Parser (Apache 2.0)",
				urlString: "https://github.com/apple/swift-argument-parser?tab=Apache-2.0-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "Swift HTTP Types (Apache 2.0)",
				urlString: "https://github.com/apple/swift-http-types?tab=Apache-2.0-1-ov-file#readme"// NOSONAR
			),
			Library(
				name: "Swift OpenAPI Generator (Apache 2.0)",
				urlString: "https://github.com/apple/swift-openapi-generator#Apache-2.0-1-ov-file" // NOSONAR
			),
			Library(name:
				"Swift OpenAPI Generator Runtime (Apache 2.0)",
				urlString: "https://github.com/apple/swift-openapi-runtime?tab=Apache-2.0-1-ov-file#Apache-2.0-1-ov-file" // NOSONAR
			),
			Library(
				name: "SwiftSoup (MIT)",
				urlString: "https://github.com/scinfu/SwiftSoup?tab=License-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "SwiftUI Introspect (MIT)",
				urlString: "https://github.com/siteline/SwiftUI-Introspect?tab=MIT-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "SwiftUI NavigationStack Backport (MIT)",
				urlString: "https://github.com/lm/navigation-stack-backport?tab=MIT-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "URLSession Transport for Swift OpenAPI Generator (Apache 2.0)",
				urlString: "https://github.com/apple/swift-openapi-urlsession?tab=Apache-2.0-1-ov-file#readme" // NOSONAR
			),
			Library(
				name: "ViewInspector 🕵️‍♂️ for SwiftUI (MIT)",
				urlString: "https://github.com/nalexn/ViewInspector?tab=MIT-1-ov-file#readme" // NOSONAR
			)
		]
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AboutOpenSourceLibrariesViewModel.Action) {
		
		if case .openUrl(let urlString) = action {
			let params: [String: AnyHashable] = ["urlString": urlString]
			coordinator?.handle(
				Coordination.Action(
					identifier: Coordination.Action.openUrl.identifier,
					params: params
				)
			)
		}
	}
}

struct AboutOpenSourceLibrariesView: View {
	
	/// The View Model
	@StateObject var viewModel: AboutOpenSourceLibrariesViewModel
	
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
		enum Row {
			static let spacing: CGFloat = 4
		}
	}
	
	var body: some View {
		
		List {
			Section {
				list()
			} header: {
				header()
			}
			.listRowInsets(ViewTraits.General.inset)
		}
		.backportScrollContentBackground(.hidden)
		.backportContentMargins(ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationTitle("settings.about_this_app.open_source")
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	/// Get the header for the list
	/// - Returns: the list header
	@ViewBuilder private func header() -> some View {
		
		Text("settings.about_this_app.open_source.subheading")
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundStyle(theme.contentPrimary)
			.textCase(nil)
			.padding(.top, ViewTraits.Navigation.padding)
			.when(isIOS16OrOlder) { view in
				view
					.padding(.bottom, ViewTraits.Navigation.padding)
			}
			.accessibilityIdentifier("settings.about_this_app.open_source.subheading")
	}
	
	/// Get a list of libraries
	/// - Returns: a list of libraries
	@ViewBuilder private func list() -> some View {
		
		ForEach(viewModel.libraries, id: \.id) { library in
			viewForOpenSourceLibrary(library)
		}
	}
	
	/// Build a view for the open source libraries used
	/// - Parameters:
	///   - heading: the title of the library
	///   - urlString: the url to the license
	/// - Returns: Button for the open source library
	@ViewBuilder private func viewForOpenSourceLibrary(_ library: AboutOpenSourceLibrariesViewModel.Library) -> some View {
		
		Button {
			viewModel.reduce(.openUrl(library.urlString))
		} label: {
			
			HStack(spacing: ViewTraits.General.padding) {
				
				Text(library.name)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.interactionTertiaryDefaultText)
					 
					 Spacer()
					 
					 Image(ImageResource.Settings.arrowOutward)
					.tint(theme.symbolSecondary)
			}
		}
		.accessibilityIdentifier("Button \(library.name)")
		.padding(ViewTraits.General.padding)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AboutOpenSourceLibrariesView(viewModel: AboutOpenSourceLibrariesViewModel(coordinator: nil))
	}
}
