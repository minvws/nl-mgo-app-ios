/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import Managers

class LaunchViewModel: ObservableObject {
	
	weak var coordinator: (any Coordinator)?
	
	// All possible states for this ViewModel
	enum State {
		case idle // Initial State
		case loadingConfig // Loading the config
		case configLoaded // Config is loaded (mocked for now, so no error state)
	}
	
	/// All possible actions for this ViewModel
	enum Action {
		case start
		case reset
		case loaded
	}
	
	@Published var state: State
	
	init(coordinator: (any Coordinator)?, state: State = .idle) {
		self.coordinator = coordinator
		self.state = state
		
		setupObservers()
	}
	
	/// Setup all the observers
	private func setupObservers() {
		
		// Listen for reset notification
		Current.notificationCenter.addObserver(forName: .resetApplication, object: nil, queue: OperationQueue.main) { _ in
			self.reduce(.reset)
		}
	}
	
	/// Reduce the action to the next state
	/// - Parameter action: the action
	func reduce(_ action: LaunchViewModel.Action) {
		
		switch action {
			case .start:
			
				guard state == .idle else { return }
				state = .loadingConfig
				loadConfig()
			
			case .reset:
				state = .loadingConfig
				loadConfig()
			
			case .loaded:
				state = .configLoaded
				coordinator?.handle(Coordination.Action.finishedLoading)
		}
	}
	
	internal func loadConfig(_ timeInterval: TimeInterval = 1.0) {
		
		// Mocked for now, just take 1 seconds to finish
		DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
			self.reduce(.loaded)
		}
	}
}

struct LaunchView: View {
	
	/// The View Model
	@StateObject var viewModel: LaunchViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	@State private var rijkslintTopOffset: CGFloat = 0
	@State private var spinnerBottomPadding: CGFloat = 0
	
	private struct ViewTraits {
		enum DynamicIsland {
			static let height: CGFloat = 59
			static let offset: CGFloat = 11
		}
		enum Notch {
			static let height: CGFloat = 47
			static let offset: CGFloat = 16
		}
		enum Title {
			static let topOffset: CGFloat = 64
		}
		enum Spinner {
			static let bottomOffset: CGFloat = 75
		}
		enum Rijkslint {
			static let height: CGFloat = 100
			static let width: CGFloat = 50
		}
	}
	
	/// Calculate the offset for the rijkslint so it stays just below the notch or dynamic island
	/// - Parameter safeAreaHeight: the height of the safe area
	func recalculateOffset(_ safeAreaInsets: EdgeInsets) {
		if safeAreaInsets.top >= ViewTraits.DynamicIsland.height {
			rijkslintTopOffset = safeAreaInsets.top - ViewTraits.DynamicIsland.offset
		} else if safeAreaInsets.top >= ViewTraits.Notch.height {
			rijkslintTopOffset = safeAreaInsets.top - ViewTraits.Notch.offset
		} else {
			rijkslintTopOffset = 0
		}
	}
	
	private func recalculateBottomPadding(_ safeAreaInsets: EdgeInsets) {
		spinnerBottomPadding = 70 - safeAreaInsets.bottom
	}
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				theme.backgroundPrimary
					.ignoresSafeArea()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				VStack {
					Image(ImageResource.rijkslint)
						.resizable()
						.frame(width: ViewTraits.Rijkslint.width, height: ViewTraits.Rijkslint.height)
						.padding(.top, rijkslintTopOffset)
						.ignoresSafeArea()
						.accessibilityLabel("launch_image_voiceover")
					
					Text("app_title")
						.rijksoverheidStyle(font: .bold, style: .largeTitle)
						.foregroundStyle(theme.contentPrimary)
						.padding(.top, ViewTraits.Title.topOffset - rijkslintTopOffset)
						.accessibilityAddTraits(.isHeader)
						.multilineTextAlignment(.center)
						.tag("app_title")
						.fixedSize(horizontal: false, vertical: true)
					
					Spacer()
					if viewModel.state == .loadingConfig {
						ProgressView("launch_loading")
							.tint(theme.actionPrimaryBackground)
							.rijksoverheidStyle(font: .regular, style: .body)
							.foregroundStyle(theme.contentPrimary)
							.padding(.bottom, ViewTraits.Spinner.bottomOffset - geometry.safeAreaInsets.bottom)
					}
				}
				.onAppear {
					viewModel.reduce(LaunchViewModel.Action.start)
					recalculateOffset(geometry.safeAreaInsets)
					recalculateBottomPadding(geometry.safeAreaInsets)
				}
				.onChange(of: geometry.safeAreaInsets) { insets in
					recalculateOffset(insets)
					recalculateBottomPadding(insets)
				}
			}
		}
		.navigationBarBackButtonHidden()
		.navigationBarHidden(true)
	}
}

#Preview {
	LaunchView(viewModel: LaunchViewModel(coordinator: nil))
}
