/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class StoredHealthcareProvidersViewModel: ObservableObject {
	
	/// All possible states of the box
	enum State {
		case empty
		case list([HealthcareProvider])
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case backToSearch
		case cancelDialog
		case closeSheet
		case done
		case onAppear
		case remove
		case showRemoveDialog(HealthcareProvider)
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// The state of the view
	@Published var state: State = .empty
	
	/// The name of the healthcare provider to remove
	@Published var healthcareProviderToRemoveTitle: String?
	
	/// the healthcare provider to remove
	private var healthcareProviderToRemove: HealthcareProvider?
	
	/// Initialzier
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any Coordinator)?) {
		self.coordinator = coordinator
	}
	
	/// fetch the healthcare providers
	private func loadHealthcareProviders() {

		let providers = Current.healthcareProviderStore.providers
		if providers.isEmpty {
			state = .empty
		} else {
			state = .list(providers)
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: StoredHealthcareProvidersViewModel.Action) {
		
		switch action {
		
			case .onAppear:
				loadHealthcareProviders()
			
			case .backButtonPressed:
				coordinator?.handle(Coordination.Action.backButtonPressed)
			
			case .cancelDialog:
				healthcareProviderToRemoveTitle = nil
				healthcareProviderToRemove = nil
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
			
			case .remove:
				if let provider = healthcareProviderToRemove {
					try? Current.healthcareProviderStore.remove(provider)
				}
				healthcareProviderToRemoveTitle = nil
				healthcareProviderToRemove = nil
				loadHealthcareProviders()
			
			case .backToSearch:
				Current.notificationCenter.post(name: .clearSearch, object: nil)
				coordinator?.handle(Coordination.Action.backToSearchHealthcareProvider)
				
			case .done:
				coordinator?.handle(Coordination.Action.finishedSearchingHealthcareProviders)
				
			case .showRemoveDialog(let healthcareProvider):
				healthcareProviderToRemove = healthcareProvider
				healthcareProviderToRemoveTitle = String(
					format: String(localized: "storedhp_alert_title"),
					arguments: ["\(healthcareProvider.display_name)"]
				)
			
		}
	}
}

struct StoredHealthcareProvidersView: View {
	
	/// The view model
	@StateObject var viewModel: StoredHealthcareProvidersViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
	/// Magic numbers
	private struct ViewTraits {
		enum Button {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
			static let spacing: CGFloat = 16
		}
		enum Content {
			static let spacing: CGFloat = 16
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum List {
			static let spacing: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(alignment: .leading, spacing: ViewTraits.Content.spacing) {
				
				Text("storedhp_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				switch viewModel.state {
					case .empty:
						Text("storedhp_body_empty")
							.rijksoverheidStyle(font: .regular, style: .body)
							.frame(maxWidth: .infinity, alignment: .topLeading)
					
					case let .list(list):
					
						Text("storedhp_body")
							.rijksoverheidStyle(font: .regular, style: .body)
							.frame(maxWidth: .infinity, alignment: .topLeading)
					
						LazyVStack(spacing: ViewTraits.List.spacing, content: {
							ForEach(list, id: \.self) { healthcareProvider in
								
								ZStack {
									
									Rectangle()
										.foregroundStyle(.clear)
										.accessibilityLabel(
											String(
												format: String(localized: "storedhp_remove_voiceover"),
												arguments: ["\(healthcareProvider.display_name)"]
											)
										)
										.accessibilityAddTraits(.isButton)
									
									StoredHealthcareProviderCardView(element: StoredHealthcareProviderDecorator.create(healthcareProvider))
										.onTapGesture {
											viewModel.reduce(.showRemoveDialog(healthcareProvider))
										}
									
								}
							}
						})
					
						Spacer()
				}
			}
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			VStack(spacing: ViewTraits.Button.spacing) {
				
				CallToActionButton("storedhp_action_again", style: .secondary) {
					viewModel.reduce(.backToSearch)
				}
				.tag("storedhp_action_again")
				
				CallToActionButton("storedhp_action_done") {
					viewModel.reduce(.done)
				}
				.tag("storedhp_action_done")
			}
			.padding(ViewTraits.Button.insets)
			.padding(.top, ViewTraits.General.padding)
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.alert(viewModel.healthcareProviderToRemoveTitle ?? "", isPresented: $viewModel.healthcareProviderToRemoveTitle.presence()) {
			Button("storedhp_alert_cancel", role: .cancel) { viewModel.reduce(.cancelDialog) }
			Button("storedhp_alert_remove") { viewModel.reduce(.remove) }
		} message: {
			Text("storedhp_alert_body")
		}
		.navigationBarBackButtonHidden(true)
		.if(isPresentedAsSheet, transform: { view in
			view
				.toolbar {
					ToolbarItem(content: { CloseButton {
						viewModel.reduce(.closeSheet)
					}})
				}
		})
		.navigationBarItems(leading: BackButton("searchresults_backbutton") {
			viewModel.reduce(.backButtonPressed)
		})
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
}

#Preview {
	NavigationView {
		StoredHealthcareProvidersView(viewModel: StoredHealthcareProvidersViewModel(coordinator: nil))
	}
}
