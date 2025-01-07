/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct DocumentPreviewController: UIViewControllerRepresentable {
	
	private var isActive: Binding<Bool>
	private var failedToOpen: Binding<Bool>
	private let viewController = UIViewController()
	private let docController: UIDocumentInteractionController
	
	init(_ isActive: Binding<Bool>, failedToOpen: Binding<Bool>, url: URL) {
		self.isActive = isActive
		self.failedToOpen = failedToOpen
		self.docController = UIDocumentInteractionController(url: url)
	}
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPreviewController>) -> UIViewController {
		return viewController
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DocumentPreviewController>) {
		
		if self.isActive.wrappedValue && docController.delegate == nil { // to not show twice
			docController.delegate = context.coordinator
			let result = self.docController.presentPreview(animated: true)
			context.coordinator.didOpen(result)
		}
	}
	
	func makeCoordinator() -> DocumentPreviewCoordinator {
		
		return DocumentPreviewCoordinator(owner: self, failedToOpen: failedToOpen)
	}
	
	final class DocumentPreviewCoordinator: NSObject, UIDocumentInteractionControllerDelegate { // works as delegate
		let owner: DocumentPreviewController
		
		let failedToOpen: Binding<Bool>
		
		init(owner: DocumentPreviewController, failedToOpen: Binding<Bool>) {
			self.owner = owner
			self.failedToOpen = failedToOpen
		}
		func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
			return owner.viewController
		}
		
		func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
			controller.delegate = nil // done, so unlink self
			owner.isActive.wrappedValue = false // notify external about done
		}
		
		func didOpen(_ value: Bool) {
			DispatchQueue.main.async {
				self.failedToOpen.wrappedValue = !value
			}
		}
	}
}
