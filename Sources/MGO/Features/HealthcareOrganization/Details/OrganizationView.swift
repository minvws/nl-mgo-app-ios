/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class OrganizationViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare organization to display
	private var healthcareOrganization: HealthcareOrganization
	
	/// Model to display
	@Published var organizationModel: OrganizationModel
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case showMedication
		case showProblems
		case showResults
		case removeHealthcareOrganization
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil, healthcareOrganization: HealthcareOrganization) {
		
		self.coordinator = coordinator
		self.healthcareOrganization = healthcareOrganization
		self.organizationModel = OrganizationDecorator.create(healthcareOrganization)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: OrganizationViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .showProblems:
				coordinator?.handle(Coordination.Action(
					identifier: "showProblems",
					params: ["healthcareOrganization": healthcareOrganization])
				)
			case .showMedication:
				coordinator?.handle(Coordination.Action(
					identifier: "showMedication",
					params: ["healthcareOrganization": healthcareOrganization])
				)
			case .showResults:
				coordinator?.handle(Coordination.Action(
					identifier: "showLabResults",
					params: ["healthcareOrganization": healthcareOrganization])
				)
	
			case .removeHealthcareOrganization:
				coordinator?.handle(Coordination.Action(
					identifier: "removeHealthcareOrganization",
					params: ["healthcareOrganization": healthcareOrganization])
			)
		}
	}
}

struct OrganizationView: View {

	/// The View Model
	@StateObject var viewModel: OrganizationViewModel
	
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
			static let spacing: CGFloat = 4
			static let top: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollView {
			
			VStack(alignment: .leading, spacing: ViewTraits.General.padding) {
				
				Group {
					
					Text(viewModel.organizationModel.name)
						.rijksoverheidStyle(font: .bold, style: .title)
						.foregroundStyle(theme.contentPrimary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.accessibilityAddTraits(.isHeader)
					
					Text(viewModel.organizationModel.category)
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundStyle(theme.contentTertiary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
				}
				.padding(.horizontal, ViewTraits.General.padding)

				VStack(spacing: ViewTraits.List.spacing) {
					
					ZStack {
						Rectangle()
							.foregroundStyle(.clear)
							.accessibilityLabel("organization.medicine_heading")
							.accessibilityAddTraits(.isButton)
						
							ActionCardView(
								title: "organization.medicine_heading",
								message: "organization.medicine_subheading",
								icon: .medication,
								perform: {
									viewModel.reduce(.showMedication)
								}
							)
					}
					
					ZStack {
						Rectangle()
							.foregroundStyle(.clear)
							.accessibilityLabel("organization.diagnosis_heading")
							.accessibilityAddTraits(.isButton)
						
						ActionCardView(
							title: "organization.diagnosis_heading",
							message: "organization.diagnosis_subheading",
							icon: .diagnoses,
							perform: {
								viewModel.reduce(.showProblems)
							}
						)
					}
					
					ZStack {
						Rectangle()
							.foregroundStyle(.clear)
							.accessibilityLabel("organization.lab_results_heading")
							.accessibilityAddTraits(.isButton)
						
						ActionCardView(
							title: "organization.lab_results_heading",
							message: "organization.lab_results_subheading",
							icon: .results,
							perform: {
								viewModel.reduce(.showResults)
							}
						)
					}
				}
				.padding(.top, ViewTraits.List.top)
				
				Text("common.settings")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentTertiary)
					.padding(.horizontal, ViewTraits.General.padding)
					.padding(.top, ViewTraits.List.top)
				
				ZStack {
					Rectangle()
						.foregroundStyle(.clear)
						.accessibilityLabel("organization.remove_organization_heading")
						.accessibilityAddTraits(.isButton)
					
						ActionCardView(
							title: "organization.remove_organization_heading",
							message: "organization.remove_organization_subheading",
							icon: .remove,
							perform: {
								viewModel.reduce(.removeHealthcareOrganization)
							}
						)
				}
				
				Spacer()
			}
			
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		OrganizationView(
			viewModel: OrganizationViewModel(
				coordinator: nil,
				healthcareOrganization: PreviewContent.healthcareOrganization
			)
		)
	}
}
