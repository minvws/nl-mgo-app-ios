/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct DocumentPreviewController: UIViewControllerRepresentable {
	
	private var isActive: Binding<Bool>
	private var didOpen: Binding<Bool>
	private let viewController = UIViewController()
	private let docController: UIDocumentInteractionController
	
	init(_ isActive: Binding<Bool>, didOpen: Binding<Bool>, url: URL) {
		self.isActive = isActive
		self.didOpen = didOpen
		self.docController = UIDocumentInteractionController(url: url)
	}
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPreviewController>) -> UIViewController {
		return viewController
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DocumentPreviewController>) {
		
		if self.isActive.wrappedValue && docController.delegate == nil { // to not show twice
			docController.delegate = context.coordinator
			let result = self.docController.presentPreview(animated: true)
			print("Could we open the preview? \(result)") /// how do we pass result back to the caller?
//			context.coordinator.didOpen(result)
		}
	}
	
	func makeCoordinator() -> DocumentPreviewCoordinator {
		
		return DocumentPreviewCoordinator(owner: self)
	}
	
	final class DocumentPreviewCoordinator: NSObject, UIDocumentInteractionControllerDelegate { // works as delegate
		let owner: DocumentPreviewController
		
		init(owner: DocumentPreviewController) {
			self.owner = owner
		}
		func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
			return owner.viewController
		}
		
		func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
			controller.delegate = nil // done, so unlink self
			owner.isActive.wrappedValue = false // notify external about done
		}
		
		func didOpen(_ value: Bool) {
			owner.didOpen.wrappedValue = value
		}
	}
}
