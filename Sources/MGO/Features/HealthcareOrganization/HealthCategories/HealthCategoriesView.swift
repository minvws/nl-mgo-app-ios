/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// The various states the page can be in
enum HealthCategoriesViewMode {
	
	/// This is a detailed single healthcare organization
	case single(MgoOrganization)
	
	/// This is an overview of all your healthcare organizations
	case multiple([MgoOrganization])
}

struct HealthCategoriesViewState {
	
	var title: String
	var showRemoveHealthcareProvider: Bool
	var healthCategories: [CategoryButton]
	var backbuttonTitle: LocalizedStringKey
	
	mutating func updateCategoryState(id: Int, state: CategoryButtonState) {
		withAnimation {
			for index in 0..<healthCategories.count where healthCategories[index].id == id {
				healthCategories[index].state = state
			}
		}
	}
}

class HealthCategoriesViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The mode we are in (single, multiple)
	private var mode: HealthCategoriesViewMode
	
	/// The state of the view
	@Published var state: HealthCategoriesViewState
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case refresh
		case categorySelected(Int)
		case removeHealthcareOrganization
		case onAppear
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil, mode: HealthCategoriesViewMode) {
		
		self.coordinator = coordinator
		self.mode = mode
		
		let title: String = switch mode {
			case .single(let mgoOrganization):
				mgoOrganization.display_name
			case .multiple:
				String(localized: "health_categories.heading")
		}
		
		let backbuttonTitle: LocalizedStringKey = switch mode {
			case .single: "health_categories.back"
			case .multiple: "general.previous"
		}
		
		self.state = HealthCategoriesViewState(
			title: title,
			showRemoveHealthcareProvider: true,
			healthCategories: [
				HealthCategories.medication,
				HealthCategories.allergies,
				HealthCategories.measurements,
				HealthCategories.vaccinations,
				HealthCategories.reports,
				HealthCategories.documents,
				HealthCategories.complaints,
				HealthCategories.treatments,
				HealthCategories.labresults
			],
			backbuttonTitle: backbuttonTitle
		)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthCategoriesViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			
			case .refresh:
				logInfo("Todo: Pull to refresh")
			
			case let .categorySelected(identifier):
				logInfo("tapped on", identifier)
			
			case .onAppear:
			_Concurrency.Task {
				await loadMedication(id: 1)
			}
			
			case .removeHealthcareOrganization:
				if case let .single(healthcareOrganization) = mode {
					coordinator?.handle(
						Coordination.Action(
							identifier: "removeHealthcareOrganization",
							params: ["healthcareOrganization": healthcareOrganization]
						)
					)
				}
		}
	}
	
	@MainActor
	func loadMedication(id: Int) async {
		
		let medicationUseRepository: MedicationUseRepository? = FHIRClient()
		
		if case let .single(healthcareOrganization) = mode {

			guard let resourceEndpoint = healthcareOrganization.getResourceEndpoint(identifier: DVP.CommonClinicalDataset.serviceID) else {

				state.updateCategoryState(id: id, state: .empty)
				return
			}
			do {
				guard let results = try await medicationUseRepository?.fetchMedicationUse(dvaTarget: resourceEndpoint) else {
					state.updateCategoryState(id: id, state: .empty)
					return
				}
					
				if results.isEmpty {
					state.updateCategoryState(id: id, state: .empty)
				} else {
					state.updateCategoryState(id: id, state: .loaded)
				}
				
			} catch {
				logError("Client read error: \(String(describing: error))")
				state.updateCategoryState(id: id, state: .empty)
			}
		}
	}
}

struct HealthCategoriesView: View {

	/// The View Model
	@StateObject var viewModel: HealthCategoriesViewModel
	
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
			static let rowInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
			
		VStack(alignment: .leading, spacing: 0) {
			
			Text(viewModel.state.title)
				.rijksoverheidStyle(font: .bold, style: .title)
				.foregroundStyle(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
				.padding(.horizontal, ViewTraits.General.padding)
				.padding(.top, ViewTraits.Navigation.padding)
			
			List {
				
				ForEach(CategoryButtonState.allCases, id: \.self) { category in
					
					Section {
						
						let list = viewModel.state.healthCategories
							.filter { $0.state == category }
							.sorted(by: { $0.id < $1.id })
						
						ForEach(list, id: \.id) { block in
						
							VStack(spacing: 0) {
								HealthCategoryRowView(block: block)
									.when(block.state == .loaded) { view in
										Button(action: {
											viewModel.reduce(.categorySelected(block.id))
										}, label: {
											view
										})
									}
							}
						}
					}
					.listRowInsets(ViewTraits.List.rowInset)
				}
				
				if viewModel.state.showRemoveHealthcareProvider {
					Section { /* Empty section */ }
					footer: {
						// Button in footer of an empty section so it is
						// at the bottom of the list, and without a rounded list background
						CallToActionButton(
							"health_categories.remove_organization",
							style: .tertiaryNegative) {
								viewModel.reduce(.removeHealthcareOrganization)
							}
					}
				}
			} // List
			.listStyle(.insetGrouped)
			.backportListSectionSpacing(ViewTraits.List.spacing)
			
			Spacer()

		} // VStack
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton(viewModel.state.backbuttonTitle) {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
		.refreshable {
			viewModel.reduce(.refresh)
		}.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthCategoriesView(
			viewModel: HealthCategoriesViewModel(
				coordinator: nil,
				mode: .single(PreviewContent.healthcareOrganization)
			)
		)
	}
}
