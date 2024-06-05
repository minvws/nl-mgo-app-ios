/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Resource {
	
	/// Resolve a reference to a resource from a bundle
	/// - Parameters:
	///   - reference: the reference to resolve
	///   - bundle: the bundle to resolve from
	/// - Returns: a resolved Resource
	public func resolve<T: Resource>(_ reference: Reference?, from bundle: ModelsSTU3.Bundle) -> T? {
		
		guard let ref = reference?.reference?.value?.string else { return nil }
		
		let targets: [T] = bundle.entry?.compactMap {
			guard let absoluteString = $0.fullUrl?.value?.url.absoluteString else { return nil }
			return absoluteString.hasSuffix(ref) ? $0.resource?.get(if: T.self) : nil
		} ?? []

		return targets.first
	}
}
