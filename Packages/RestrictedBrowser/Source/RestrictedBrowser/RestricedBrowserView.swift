/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct RestricedBrowserView: View {
	
	/// Initializer
	/// - Parameter viewModel: the view model
	public init(viewModel: RestricedBrowserViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}
	
	@StateObject var viewModel: RestricedBrowserViewModel
	
	public var body: some View {
		
		WebView(viewModel: viewModel, url: viewModel.url)
			.background(.white)
			.toolbar {
				ToolbarItemGroup(placement: .bottomBar) {
					Spacer()
					Button {
						viewModel.reduce(.safariButtonPressed)
					} label: {
						Image(systemName: "safari")
					}
				}
			}
	}
}
