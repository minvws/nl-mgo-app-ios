/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import QuickLook

// See https://nilcoalescing.com/blog/PreviewFilesWithQuickLookInSwiftUI/

struct DocumentPreviewController: UIViewControllerRepresentable {
	private let url: URL
	private var isActive: Binding<Bool>
	private var failedToOpen: Binding<Bool>
	
	init(_ isActive: Binding<Bool>, failedToOpen: Binding<Bool>, url: URL) {
		self.isActive = isActive
		self.failedToOpen = failedToOpen
		self.url = url
	}
	
	func makeUIViewController(context: Context) -> UINavigationController {
		
		let controller = QLPreviewController()
		controller.dataSource = context.coordinator
		controller.delegate = context.coordinator
		
		controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done, target: context.coordinator,
			action: #selector(context.coordinator.dismiss)
		)
		
		let navigationController = UINavigationController(rootViewController: controller)
		return navigationController
	}
	
	// MARK: UIViewControllerRepresentable
	
	func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
		/* No operation */
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(parent: self)
	}
	
	class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
		
		var parent: DocumentPreviewController
		
		init(parent: DocumentPreviewController) {
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
			didOpen(QLPreviewController.canPreview(parent.url as QLPreviewItem))
			return parent.url as QLPreviewItem
		}
		
		// MARK: QLPreviewControllerDelegate
		
		func previewController(_ controller: QLPreviewController, editingModeFor previewItem: any QLPreviewItem) -> QLPreviewItemEditingMode {
			return .disabled
		}
		
		// MARK: Navigation
		
		@objc func dismiss() {
			parent.isActive.wrappedValue = false
		}
		
		func didOpen(_ value: Bool) {
			DispatchQueue.main.async {
				self.parent.failedToOpen.wrappedValue = !value
			}
		}
	}
}
