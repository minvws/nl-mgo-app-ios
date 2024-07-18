/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class OrganizationListViewModel: ObservableObject {
	
	/// All possible states of the box
	enum State {
		case empty
		case list([MgoOrganization])
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
		case showRemoveDialog(MgoOrganization)
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// The state of the view
	@Published var state: State = .empty
	
	/// The name of the healthcare organization to remove
	@Published var healthcareOrganizationToRemoveTitle: String?
	
	/// the healthcare organization to remove
	private var healthcareOrganizationToRemove: MgoOrganization?
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any Coordinator)?) {
		self.coordinator = coordinator
	}
	
	/// fetch the healthcare organization
	private func loadHealthcareOrganizations() {

		let organizations = Current.healthcareOrganizationStore.organizations
		if organizations.isEmpty {
			state = .empty
		} else {
			state = .list(organizations)
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: OrganizationListViewModel.Action) {
		
		switch action {
		
			case .onAppear:
				loadHealthcareOrganizations()
			
			case .backButtonPressed:
				coordinator?.handle(Coordination.Action.backButtonPressed)
			
			case .cancelDialog:
				healthcareOrganizationToRemoveTitle = nil
				healthcareOrganizationToRemove = nil
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
			
			case .remove:
				if let organization = healthcareOrganizationToRemove {
					try? Current.healthcareOrganizationStore.remove(organization)
				}
				healthcareOrganizationToRemoveTitle = nil
				healthcareOrganizationToRemove = nil
				loadHealthcareOrganizations()
			
			case .backToSearch:
				Current.notificationCenter.post(name: .clearSearch, object: nil)
				coordinator?.handle(Coordination.Action.backToAddHealthcareOrganization)
				
			case .done:
				coordinator?.handle(Coordination.Action.finishedSearchingHealthcareOrganizations)
				
			case .showRemoveDialog(let healthcareOrganization):
				healthcareOrganizationToRemove = healthcareOrganization
				healthcareOrganizationToRemoveTitle = String(
					format: String(localized: "dialog.remove_organization_heading"),
					arguments: ["\(healthcareOrganization.display_name)"]
				)
			
		}
	}
}

struct OrganizationListView: View {
	
	/// The view model
	@StateObject var viewModel: OrganizationListViewModel
	
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
				
				Text("organization_list.heading")
					.rijksoverheidStyle(font: .bold, style: .title)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.accessibilityIdentifier("organization_list.heading")
				
				switch viewModel.state {
					case .empty:
					
					NotificationCardView(
						icon: Image(ImageResource.Woman.womanOnCouch),
						title: "organization_list.no_results_heading",
						message: "organization_list.no_results_subheading"
					)
					
					case let .list(list):
					
						Text("organization_list.subheading")
							.rijksoverheidStyle(font: .regular, style: .body)
							.frame(maxWidth: .infinity, alignment: .topLeading)
					
						LazyVStack(spacing: ViewTraits.List.spacing, content: {
							ForEach(list, id: \.self) { healthcareOrganization in
								
								ZStack {
									
									Rectangle()
										.foregroundStyle(.clear)
										.accessibilityLabel(
											String(
												format: String(localized: "remove_organization.heading"),
												arguments: ["\(healthcareOrganization.display_name)"]
											)
										)
										.accessibilityAddTraits(.isButton)
									
									OrganizationListCardView(
										model: OrganizationListDecorator.create(healthcareOrganization),
										perform: {
											viewModel.reduce(.showRemoveDialog(healthcareOrganization))
										}
									)
								}
							}
						})
					
						Spacer()
				}
			}
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			
			bottomView()
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.alert(viewModel.healthcareOrganizationToRemoveTitle ?? "", isPresented: $viewModel.healthcareOrganizationToRemoveTitle.presence()) {
			Button("dialog.remove_organization_no", role: .cancel) { viewModel.reduce(.cancelDialog) }
			Button("dialog.remove_organization_yes") { viewModel.reduce(.remove) }
		} message: {
			Text("dialog.remove_organization_subheading")
		}
		.navigationBarBackButtonHidden(true)
		.when(isPresentedAsSheet, transform: { view in
			view
				.toolbar {
					ToolbarItem(content: { CloseButton {
						viewModel.reduce(.closeSheet)
					}})
				}
		})
		.navigationBarItems(leading: BackButton("common.search") {
			viewModel.reduce(.backButtonPressed)
		})
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
	
	/// Get the call to action buttons view
	/// - Returns: View containing the call to action buttons
	@ViewBuilder func bottomView() -> some View {
		
		VStack(spacing: ViewTraits.Button.spacing) {
			
			switch viewModel.state {
				case .empty:
					// Primary CTA in empty state is to
					// add a healthcare organization
					// Secondary go to overview
					
					CallToActionButton("organization_list.to_overview", style: .secondary) {
						viewModel.reduce(.done)
					}
					.tag("organization_list.to_overview")
					
					CallToActionButton("organization_list.add_organization") {
						viewModel.reduce(.backToSearch)
					}
					.tag("organization_list.add_organization")
					
				case .list:
					// We already have an organization, so
					// primary CTA is to go to the overview.
					// secondary CTA is to add another organization
					CallToActionButton("organization_list.add_organization", style: .secondary) {
						viewModel.reduce(.backToSearch)
					}
					.tag("organization_list.add_organization")
					
					CallToActionButton("organization_list.to_overview") {
						viewModel.reduce(.done)
					}
					.tag("organization_list.to_overview")
			}
		}
		.padding(ViewTraits.Button.insets)
		.padding(.top, ViewTraits.General.padding)
	}
}

#Preview {
	NavigationView {
		OrganizationListView(viewModel: OrganizationListViewModel(coordinator: nil))
	}
}
