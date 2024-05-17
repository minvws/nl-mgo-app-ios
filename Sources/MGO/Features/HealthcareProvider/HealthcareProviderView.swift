/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class HealthcareProviderViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The healthcare provider to display
	private var healthcareProvider: HealthcareProvider
	
	/// Model to display
	@Published var providerModel: HealthcareProviderModel

	/// Token for the observatory (needed for unregister)
	private var observerToken: Observatory.ObserverToken?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case medication
		case diagnoses
		case results
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil, healthcareProvider: HealthcareProvider) {
		
		self.coordinator = coordinator
		self.healthcareProvider = healthcareProvider
		self.providerModel = HealthcareProviderDecorator.create(healthcareProvider)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthcareProviderViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .medication:
				break
			case .diagnoses:
				break
			case .results:
				break
		}
	}
}

struct HealthcareProviderView: View {

	/// The View Model
	@StateObject var viewModel: HealthcareProviderViewModel
	
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
			
			VStack(spacing: ViewTraits.General.padding) {
				
				Group {
					
					Text(viewModel.providerModel.name)
						.rijksoverheidStyle(font: .bold, style: .title)
						.foregroundStyle(theme.contentPrimary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.accessibilityAddTraits(.isHeader)
					
					Text(viewModel.providerModel.category)
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundStyle(theme.contentTertiary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
				}
				.padding(.horizontal, ViewTraits.General.padding)

				VStack(spacing: ViewTraits.List.spacing) {
					
					ZStack {
						Rectangle()
							.foregroundStyle(.clear)
							.accessibilityLabel("hpdetails_medication_title")
							.accessibilityAddTraits(.isButton)
						
							HealthcareProviderActionCardView(
								title: "hpdetails_medication_title",
								message: "hpdetails_medication_body",
								icon: ImageResource.Details.medication,
								iconColor: theme.verpleeghuis,
								perform: {
									viewModel.reduce(.medication)
								}
							)
					}
					
					ZStack {
						Rectangle()
							.foregroundStyle(.clear)
							.accessibilityLabel("hpdetails_diagnoses_title")
							.accessibilityAddTraits(.isButton)
						
						HealthcareProviderActionCardView(
							title: "hpdetails_diagnoses_title",
							message: "hpdetails_diagnoses_body",
							icon: ImageResource.Details.diagnoses,
							iconColor: theme.tandarts,
							perform: {
								viewModel.reduce(.diagnoses)
							}
						)
					}
					
					ZStack {
						Rectangle()
							.foregroundStyle(.clear)
							.accessibilityLabel("Todo")
							.accessibilityAddTraits(.isButton)
						
						HealthcareProviderActionCardView(
							title: "hpdetails_results_title",
							message: "hpdetails_results_body",
							icon: ImageResource.Details.results,
							iconColor: theme.fysiotherapeut,
							perform: {
								viewModel.reduce(.results)
							}
						)
					}
				}
				.padding(.top, ViewTraits.List.top)
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
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthcareProviderView(
			viewModel: HealthcareProviderViewModel(
				coordinator: nil,
				healthcareProvider: HealthcareProvider(
					display_name: "Tandarts Tandje Erbij",
					identification_type: "type",
					identification_value: "1",
					active: true,
					addresses: [Components.Schemas.Address(
						active: true,
						address: "Boorplatform 5",
						city: "Roermond",
						lines: ["Boorplatform 5"],
						postalcode: "1234AB",
						_type: "postal")
					],
					names: [],
					types: [Components.Schemas.CType(code: "01", display_name: "Tandarts", _type: "")],
					data_services: []
				)
			)
		)
	}
}
