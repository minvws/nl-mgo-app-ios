/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class LaunchViewModel: ObservableObject {
	
	weak var coordinator: (any AppCoordinatorProtocol)?
	
	// All possible states for this ViewModel
	enum State {
		case idle // Initial State
		case loadingConfig // Loading the config
		case configLoaded // Config is loaded (mocked for now, so no error state)
	}
	
	/// All possible actions for this ViewModel
	enum Action {
		case start
	}
	
	@Published var state: State
	
	init(coordinator: (any AppCoordinatorProtocol)?, state: State = .idle) {
		self.coordinator = coordinator
		self.state = state
	}
	
	/// Reduce the action to the next state
	/// - Parameter action: the action
	func reduce(_ action: LaunchViewModel.Action) {
		guard state == .idle else { return }
		switch action {
			case .start:
				state = .loadingConfig
				loadConfig()
		}
	}
	
	internal func loadConfig(_ timeInterval: TimeInterval = 4.0) {
		// Mocked for now, just take 4 seconds to finish
		DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
			self.state = .configLoaded
			self.coordinator?.handle(.finishedLoading)
		}
	}
}

struct LaunchView: View {
	
	@StateObject var viewModel: LaunchViewModel
	
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
				Color.Styleguide.background
					.ignoresSafeArea()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				VStack {
					Image(ImageResource.rijkslint)
						.padding(.top, rijkslintTopOffset)
						.ignoresSafeArea()
					
					Text("app_title")
						.rijksoverheidStyle(font: .bold, style: .largeTitle)
						.foregroundColor(Color.Styleguide.black)
						.padding(.top, ViewTraits.Title.topOffset - rijkslintTopOffset)
						.accessibilityAddTraits(.isHeader)
						.multilineTextAlignment(.center)
						.tag("app_title")
						.fixedSize(horizontal: false, vertical: true)
					
					Spacer()
					if viewModel.state == .loadingConfig {
						ProgressView("launch_loading")
							.tint(Color.Styleguide.Blue.skyBlue)
							.rijksoverheidStyle(font: .regular, style: .footnote)
							.foregroundColor(Color.Styleguide.black)
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
