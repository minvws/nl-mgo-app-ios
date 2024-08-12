/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import JavaScriptCore

enum ZibDetailViewState: Equatable {
	
	case loading
	case failure
	case empty
	case success(schema: UISchema)
	
	static func == (lhs: ZibDetailViewState, rhs: ZibDetailViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
				
			case (.failure, .failure):
				return true
				
			case (.empty, .empty):
				return true
				
			case let(.success(lhsSchema), .success(rhsSchema)):
				return lhsSchema == rhsSchema
				
			default:
				return false
		}
	}
}

class ZibDetailViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: ZibDetailViewState
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare organization to display
	@Published var healthcareOrganization: MgoOrganization
	
	/// The repository for Medication Use
	private var medicationUseRepository: MedicationUseRepository!
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case onAppear
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	/// - Parameter healthcareOrganization: the healthcare organization
	/// - Parameter repository: the repository
	init(
		coordinator: (any Coordinator)? = nil,
		healthcareOrganization: MgoOrganization,
		repository: MedicationUseRepository? = FHIRClient()
	) {
		self.coordinator = coordinator
		self.healthcareOrganization = healthcareOrganization
		
		if let unwrapped = repository {
			self.medicationUseRepository = unwrapped
			self.state = .loading
		} else {
			self.state = .failure
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: MedicationListViewModel.Action) {
		
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
	/// Load the medication for the healthcare organization
	func loadMedication() async {
		
		guard let resourceEndpoint = healthcareOrganization.getResourceEndpoint(identifier: DVP.CommonClinicalDataset.serviceID) else {
			state = .empty
			return
		}
		
		do {
			let schema = try await medicationUseRepository.fetchMedicationSchema(dvaTarget: resourceEndpoint)
			if let schema {
				state = .success(schema: schema)
			} else {
				state = .empty
			}
		} catch {
			logError("Client read error: \(String(describing: error))")
			state = .failure
		}
	}
}

struct ZibDetailsView: View {
	
	/// The View Model
	@StateObject var viewModel: ZibDetailViewModel
	
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
	}
	//
	var body: some View {
		
		ScrollView {
			
			VStack(spacing: ViewTraits.General.padding) {

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
					
					case let .success(schema):
					
						UISchemaView(schema: schema)
				}
				Spacer()
			}
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("zib_details.back") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.layoutForIPad()
	}
}
//
//#Preview {
//	NavigationStackBackport.NavigationStack {
//		MedicationListView(
//			viewModel: MedicationListViewModel(
//				coordinator: nil,
//				healthcareOrganization: PreviewContent.healthcareOrganization
//			)
//		)
//	}
//}

struct UISchemaView: View {
	
	/// The schema
	var schema: UISchema
	
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
			static let padding: CGFloat = 8
			static let bottom: CGFloat = 16
			static let cornerRadius: CGFloat = 8
		}
		enum Row {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 4
		}
	}
	
	var body: some View {
		
		VStack(spacing: ViewTraits.List.padding) {
			ForEach(schema.children, id: \.self) { schemaGroup in
				viewFor(schemaGroup)
			}
		}
	}
	
	/// Show a block of rows
	/// - Parameter schemaGroup: the schemaGroup to display
	/// - Returns: block of rows
	@ViewBuilder func viewFor(_ schemaGroup: UISchemaGroup) -> some View {
		
		// Section labels
		
		Text(.init(stringLiteral: schemaGroup.label))
			.rijksoverheidStyle(font: .bold, style: .body)
			.foregroundStyle(theme.contentPrimary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityAddTraits(.isHeader)
		
		VStack(alignment: .leading) {
			ForEach(schemaGroup.children, id: \.self) { valueDescription in
				viewFor(valueDescription, isLastElement: valueDescription == schemaGroup.children.last)
			}
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.background(theme.backgroundSecondary)
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.List.cornerRadius))
		.padding(.bottom, ViewTraits.List.bottom)
	}
	
	/// Show a row of data for each child display
	/// - Parameters:
	///   - groupChild: the groupChild to display
	///   - isLastElement: Boolean indicating if this is the last element in this block
	/// - Returns: view for a groupChild
	@ViewBuilder func viewFor(_ valueDescription: ValueDescription, isLastElement: Bool) -> some View {
		
		switch valueDescription.display {
			case .string(let value):
				rowViewFor(value, heading: valueDescription.label, showDivider: !isLastElement)
				
			case .unionArray(let displayElements):
				ForEach(displayElements, id: \.self) { displayElement in
					viewFor(displayElement, valueDescription: valueDescription, isLastElement: isLastElement && displayElement == displayElements.last)
				}
				
			case .null:
				rowViewFor(String(localized: "common.unknown"), heading: valueDescription.label, showDivider: !isLastElement)
		}
	}
	
	@ViewBuilder func viewFor(_ element: DisplayElement, valueDescription: ValueDescription, isLastElement: Bool) -> some View {
		
		switch element {
			case .string(let value):
				rowViewFor(value, heading: valueDescription.label, showDivider: !isLastElement)
				.background(.orange)
				
			case .stringArray(let stringArray):
				rowViewFor(stringArray.joined(separator: ", "), heading: valueDescription.label, showDivider: !isLastElement)
				.background(.blue)
		}
	}
	
	/// Show a row of data (heading and value)
	/// - Parameters:
	///   - value: the value to display
	///   - heading: the heading to display
	///   - showDivider: True if we should show a divider at the bottom
	/// - Returns: Row View
	@ViewBuilder func rowViewFor(_ value: String, heading: String, showDivider: Bool = true) -> some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.Row.spacing) {
			
			Text(.init(stringLiteral: heading))
				.rijksoverheidStyle(font: .regular, style: .callout)
				.foregroundStyle(theme.contentTertiary)
			
			Text(Sanitizer.strip(value) ?? "common.unknown")
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
		}
		.padding(ViewTraits.Row.padding)
		
		if showDivider {
			Divider()
				.frame(height: 1)
				.overlay(theme.linesPrimary)
		}
	}
}
