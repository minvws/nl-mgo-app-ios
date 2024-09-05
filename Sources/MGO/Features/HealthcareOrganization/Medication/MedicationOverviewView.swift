/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import JavaScriptCore
import Zibs

struct OverviewBlock: Equatable, Identifiable {
	
	static func == (lhs: OverviewBlock, rhs: OverviewBlock) -> Bool {
		return lhs.heading == rhs.heading &&
		lhs.subHeading == rhs.subHeading &&
		lhs.id == rhs.id
	}

	let id = UUID()
	
	var heading: String?
	
	var subHeading: String?
	
	var action: (() -> Void)?
}

enum MedicationOverviewViewState: Equatable {
	
	case loading
	case failure
	case empty
	case success(items: [OverviewBlock])

	static func == (lhs: MedicationOverviewViewState, rhs: MedicationOverviewViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
				
			case (.failure, .failure):
				return true
				
			case (.empty, .empty):
				return true
			
			case let(.success(lhsList), .success(rhsList)):
			
				guard lhsList.count == rhsList.count else { return false }
				var result = true
				for index in lhsList.indices {
					result = result && lhsList[index] == rhsList[index]
				}
				return result
			
			default:
				return false
		}
	}
}

class MedicationOverviewViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: MedicationOverviewViewState
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	private var organizationId: String
	
	/// The text to filter the results on. 
	@Published var searchText = ""
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case onAppear
	}
	
	/// Create a MedicationOverview VM
	/// - Parameter coordinator: the app coordinator
	init(
		coordinator: (any Coordinator)? = nil,
		organizationId: String
	) {
		self.coordinator = coordinator
		self.organizationId = organizationId
		self.state = .loading
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: MedicationOverviewViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .onAppear:
				_Concurrency.Task {
					 await loadMedication()
				}
		}
	}
	
	@MainActor
	func loadMedication() async {
		
		let cacheResult = Current.dataStore.get(categoryId: "Medication", organizationId: organizationId)
		
		switch cacheResult {
			case .success(let record):
			
				var items = [OverviewBlock]()
				// For all the MgoResources
				for resource in record.resources {
					// If it is a ZibMedicationUse and we can create a UISchema from it
					if let zib = ZibFactory.createZibMedicationUse(resource),
					   let uiSchema = FHIRParser().getUiSchemaJson(resource) {
						// Add a OverviewBlock to the display list
						items.append(OverviewBlock(heading: uiSchema.label, subHeading: record.name) {
							self.coordinator?.handle(Coordination.Action(
								identifier: "showZibDetails",
								params: ["zib": zib, "uiSchema": uiSchema])
							)
						})
					}
				}
				if items.isEmpty {
					state = .empty
				} else {
					state = .success(items: items)
				}
			case .failure(let failure):
				state = .failure
		}
	}
}

struct MedicationOverviewView: View {
	
	/// The View Model
	@StateObject var viewModel: MedicationOverviewViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let top: CGFloat = 8
			static let spacing: CGFloat = 8
			static let cornerRadius: CGFloat = 8
		}
		enum NoResults {
			static let width: CGFloat = 0.5
			static let padding: CGFloat = 16
			static let top: CGFloat = 50
			static let spacing: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollView {
			
			switch viewModel.state {
				case .loading:
					
					Spacer()
					LoadingCardView(
						title: "common.loading",
						showBorder: false
					)
					
				case .empty:
					
					NotificationCardView(
						icon: Image(ImageResource.Woman.womanOnCouch),
						title: "common.no_results_heading",
						message: "common.no_results_subheading"
					)
					
				case .failure:
					
					NotificationCardView(
						icon: Image(ImageResource.Woman.womanOnCouchExclamation),
						title: "common.failure_heading",
						message: "common.failure_subheading"
					)
					
				case let .success(items):
					
					listOverviewBlocks(list: items)
			}
			
			Spacer()
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("medication_overview.back") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.large)
		.navigationTitle("medication_use.heading")
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.layoutForIPad()
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverviewBlocks(list: [OverviewBlock]) -> some View {
		
		var searchResults: [OverviewBlock] {
			if viewModel.searchText.isEmpty {
				return list
			} else {
				return list.filter {
					($0.heading?.localizedCaseInsensitiveContains(viewModel.searchText.lowercased()) ?? false) ||
					$0.subHeading?.localizedCaseInsensitiveContains(viewModel.searchText.lowercased()) ?? false
				}
			}
		}
		
		Group {
			
			if searchResults.isEmpty {
				noSearchItems()
			} else {
				LazyVStack(spacing: ViewTraits.List.spacing, content: {
					
					ForEach(Array(searchResults.enumerated()), id: \.offset) { index, element in
						
						ZStack {
							Rectangle()
								.foregroundStyle(.clear)
								.accessibilityLabel(String(
									format: String(localized: "medication_overview.voiceover"),
									arguments: ["\(element.heading ?? "")", "\(element.subHeading ?? "")"]
								))
								.accessibilityAddTraits(.isButton)
							
							ActionCardView(
								title: LocalizedStringKey(stringLiteral: element.heading ?? ""),
								message: LocalizedStringKey(stringLiteral: element.subHeading ?? ""),
								icon: .none,
								perform: element.action
							)
							.cornerRadius(ViewTraits.List.cornerRadius)
						}
						.accessibilityIdentifier("block_\(index)")
						.onTapGesture {
							element.action?()
						}
					}
				})
				.padding(.top, ViewTraits.Navigation.padding)
			}
		}
		.searchable(text: $viewModel.searchText, prompt: "medication_overview.search")
		.padding(.top, ViewTraits.List.top)
		.rijksoverheidStyle(font: .regular, style: .body)
		.foregroundColor(theme.contentTertiary)
	}
	
	/// The view for no search items
	/// - Returns: view
	@ViewBuilder func noSearchItems() -> some View {
		
		GeometryReader { geometry in
			HStack(spacing: ViewTraits.NoResults.spacing) {
				
				Spacer()
				
				VStack(alignment: .center) {
					
					// Image, 50% width
					VStack(alignment: .center) {
						Spacer()
						
						Image(ImageResource.Woman.womanWithPhoneInCircleExclamation)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.padding(.bottom, ViewTraits.NoResults.padding)
					}
					.frame(maxWidth: geometry.size.width * ViewTraits.NoResults.width)
					
					// Texts, full width
					VStack(alignment: .center) {
						
						Text("medication_overview.noresults_heading")
							.rijksoverheidStyle(font: .bold, style: .title3)
							.foregroundColor(theme.contentPrimary)
							.multilineTextAlignment(.center)
						
						Text("medication_overview.noresults_subheading")
							.rijksoverheidStyle(font: .regular, style: .body)
							.foregroundColor(theme.contentTertiary)
							.multilineTextAlignment(.center)
						
						Spacer()
					}
				}
				
				Spacer()
			}
			.padding(.top, ViewTraits.NoResults.top)
			.accessibilityElement(children: .combine)
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		MedicationOverviewView(
			viewModel: MedicationOverviewViewModel(
				coordinator: nil,
				organizationId: "1"
			)
		)
	}
}
