/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

class SplashViewModel: ObservableObject {
	
	/// The flow coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// Token for the observatory
	private var observerToken: Observatory.ObserverToken?
	
	// All possible states for this ViewModel
	enum State {
		case idle // Initial State
		case loadingConfig // Loading the config
		case configLoaded // Config is loaded
	}
	
	/// All possible actions for this ViewModel
	enum Action {
		case start
		case reset
		case loaded
		case dismissWarning
	}
	
	/// The state of the view
	@Published var state: State
	
	/// Should we show the device is jail broken dialog?
	@Published var showJailBreakDialog = false
	
	init(coordinator: (any Coordinator)?, state: State = .idle) {
		self.coordinator = coordinator
		self.state = state
		
		setupObservers()
	}
	
	deinit {
		// Remove as observer
		observerToken.map(Current.remoteConfigurationRepository.observatory.remove)
	}
	
	/// Setup all the observers
	private func setupObservers() {
		
		// Listen for reset notification
		Current.notificationCenter.addObserver(forName: .resetApplication, object: nil, queue: OperationQueue.main) { _ in
			_Concurrency.Task { @MainActor in
				self.reduce(.reset)
			}
		}
		
		// Listen to changes in the remote configuration
		observerToken = Current.remoteConfigurationRepository.observatory.append { [weak self] _ in
			
			guard let self else { return }
			// Updated configuration
			logDebug("LaunchViewModel: config loaded")
			_Concurrency.Task { @MainActor in
				self.reduce(.loaded)
			}
		}
	}
	
	/// Reduce the action to the next state
	/// - Parameter action: the action
	public func reduce(_ action: SplashViewModel.Action) {
		
		switch action {
			case .start:
			
				guard !shouldShowJailBreakWarning() else {
					showJailBreakDialog = true
					return
				}
			
				guard state == .idle else { return }
				startLoadingConfig()
			
			case .reset:
				startLoadingConfig()
			
			case .loaded:
				state = .configLoaded
				coordinator?.handle(Coordination.Action.finishedLoading)
			
			case .dismissWarning:
				// Mark warning as seen.
				Current.secureUserSettings.userHasSeenJailBreakWarning = true
				startLoadingConfig()
		}
	}
	
	/// Determine if we should show the jail break warning
	/// - Returns: True if we should show the dialog
	private func shouldShowJailBreakWarning() -> Bool {
		
		return !Current.secureUserSettings.userHasSeenJailBreakWarning && Current.jailBreakDetector.isJailBroken()
	}
	
	/// Load the remote Config
	private func startLoadingConfig() {
		
		state = .loadingConfig
		Current.remoteConfigurationRepository.fetchAndUpdateObservers()
	}
}

struct SplashView: View {
	
	/// The View Model
	@StateObject var viewModel: SplashViewModel
	
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
						.accessibilityLabel("launch.image.voiceover")
					
					Text("common.app_name")
						.rijksoverheidStyle(font: .bold, style: .largeTitle)
						.foregroundStyle(theme.contentPrimary)
						.padding(.top, ViewTraits.Title.topOffset - rijkslintTopOffset)
						.accessibilityAddTraits(.isHeader)
						.multilineTextAlignment(.center)
						.tag("common.app_name")
						.fixedSize(horizontal: false, vertical: true)
					
					Spacer()
					if viewModel.state == .loadingConfig {
						ProgressView("common.loading")
							.tint(theme.actionPrimaryBackground)
							.rijksoverheidStyle(font: .regular, style: .body)
							.foregroundStyle(theme.contentPrimary)
							.padding(.bottom, ViewTraits.Spinner.bottomOffset - geometry.safeAreaInsets.bottom)
					}
				}
				.onAppear {
					viewModel.reduce(SplashViewModel.Action.start)
					recalculateOffset(geometry.safeAreaInsets)
					recalculateBottomPadding(geometry.safeAreaInsets)
				}
				.onChange(of: geometry.safeAreaInsets) { insets in
					recalculateOffset(insets)
					recalculateBottomPadding(insets)
				}
			}
			.alert("launch.jailbreak_heading", isPresented: $viewModel.showJailBreakDialog ) {
				Button("common.ok") { viewModel.reduce(.dismissWarning) }
			} message: {
				Text("launch.jailbreak_subheading")
			}
		}
		.navigationBarBackButtonHidden()
		.navigationBarHidden(true)
	}
}

#Preview {
	SplashView(viewModel: SplashViewModel(coordinator: nil))
}
