/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	/// Create a splash view
	/// - Parameters:
	///   - coordinator: the flow coordinator
	///   - state: initial state
	init(coordinator: (any Coordinator)?, state: State = .idle) {
		self.coordinator = coordinator
		self.state = state
		
		setupObservers()
		startServices()
	}
	
	deinit {
		// Remove as observer
		observerToken.map(Current.remoteConfigurationRepository.observatory.remove)
	}
	
	/// Start the services fetching remote data
	private func startServices() {
		
		Current.remoteConfigurationRepository.fetchAndUpdateObservers()
		Current.resourceRepository.load()
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
				coordinator?.handle(Coordination.Action.finishedSplash)
			
			case .reset:
				startLoadingConfig()
			
			case .loaded:
				state = .configLoaded
				coordinator?.handle(Coordination.Action.finishedSplash)
			
			case .dismissWarning:
				// Mark warning as seen.
				Current.secureUserSettings.userHasSeenJailBreakWarning = true
				coordinator?.handle(Coordination.Action.finishedSplash)
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
		startServices()
		coordinator?.handle(Coordination.Action.finishedSplash)
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
			.alert("launch.jailbreak_heading", isPresented: $viewModel.showJailBreakDialog ) {
				Button("common.ok") { viewModel.reduce(.dismissWarning) }
			} message: {
				Text("launch.jailbreak_subheading")
			}
	}
}

#Preview {
	SplashView(viewModel: SplashViewModel(coordinator: nil))
}
