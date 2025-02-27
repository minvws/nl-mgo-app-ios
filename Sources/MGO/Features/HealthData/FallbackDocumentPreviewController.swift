/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import QuickLook

struct FallbackDocumentPreviewController: UIViewControllerRepresentable {
	let url: URL
	private var isActive: Binding<Bool>
	
	init(_ isActive: Binding<Bool>, url: URL) {
		self.isActive = isActive
		self.url = url
	}
	
	func makeUIViewController(context: Context) -> UINavigationController {
		let controller = QLPreviewController()
		controller.dataSource = context.coordinator
		controller.delegate = context.coordinator
		
		controller.navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done, target: context.coordinator,
			action: #selector(context.coordinator.dismiss)
		)
		
		let navigationController = UINavigationController(rootViewController: controller)
		return navigationController
	}
	
	func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
		/* No operation */
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(parent: self)
	}
	
	class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
		
		var parent: FallbackDocumentPreviewController
		
		init(parent: FallbackDocumentPreviewController) {
			self.parent = parent
		}
		
		// MARK: QLPreviewControllerDataSource
		
		func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
			return 1
		}
		
		func previewController(
			_ controller: QLPreviewController,
			previewItemAt index: Int
		) -> QLPreviewItem {
			return parent.url as NSURL
		}
		
		// MARK: QLPreviewControllerDelegate
		
		func previewController(_ controller: QLPreviewController, editingModeFor previewItem: any QLPreviewItem) -> QLPreviewItemEditingMode {
			return .disabled
		}
		
		// MARK: Navigation
		
		@objc func dismiss() {
			parent.isActive.wrappedValue = false
		}
	}
}
