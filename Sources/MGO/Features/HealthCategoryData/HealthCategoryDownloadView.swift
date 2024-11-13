/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import Zibs

enum HealthCategoryDownloadState {
	
	case loading
	case idle
}

class HealthCategoryDownloadViewModel: ObservableObject {
	
	@Published var state: HealthCategoryDownloadState = .idle
	
	private var healthcareOrganization: MgoOrganization
	
	@Published var entry: UIEntry
	
	/// Create a Download View
	/// - Parameters:
	///   - healthcareOrganization: the healthcare organization
	///   - entry: the UI Entry with download link
	init(healthcareOrganization: MgoOrganization, entry: UIEntry) {
		self.healthcareOrganization = healthcareOrganization
		self.entry = entry
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case download
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthCategoryDownloadViewModel.Action) {
	
		if action == .download {
			
			guard state != .loading else { return }
			state = .loading
			
			logInfo("Tapped on", entry.url as Any)
			_Concurrency.Task {
				await Current.resourceRepository.loadBinary(healthcareOrganization, serviceId: "51", url: entry.url!)
			}
		}
	}
}

struct HealthCategoryDownloadView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthCategoryDownloadViewModel
	
	var body: some View {
		
		if viewModel.entry.type == UIEntryType.downloadLink {
			CallToActionButton(
				title: viewModel.entry.label,
				icon: Image(ImageResource.Schema.download),
				style: viewModel.state == .loading ? .primaryWithSpinner : .primaryWithIcon) {
					viewModel.reduce(.download)
				}
		} else {
			EmptyView()
		}
	}
}
