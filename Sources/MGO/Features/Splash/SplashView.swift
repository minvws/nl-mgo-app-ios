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
	
	/// Should we show the loading spinner?
	@State private var showSpinner: Bool = false
	
	var body: some View {
		
		SnapshotView(showSpinner: $showSpinner)
			.onAppear {
				viewModel.reduce(SplashViewModel.Action.start)
			}
			.navigationBarBackButtonHidden()
			.navigationBarHidden(true)
			.onChange(of: viewModel.state) { newValue in
				showSpinner = newValue == .loadingConfig
			}
	}
}

#Preview {
	SplashView(viewModel: SplashViewModel(coordinator: nil))
}
