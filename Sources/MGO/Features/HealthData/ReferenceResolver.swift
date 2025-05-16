/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

protocol ReferenceResolverProtocol: AnyObject {
	
	func resolve(reference: String, healthcareOrganization: MgoOrganization) -> (Data, HealthUISchema)?
}

class ReferenceResolver: ReferenceResolverProtocol {
	
	func resolve(reference: String, healthcareOrganization: MgoOrganization) -> (Data, HealthUISchema)? {

		logVerbose("Trying to resolve reference: \(reference)")
			
		let fetchResult = Current.dataStore.get(organizationId: healthcareOrganization.identifier)
				
		if case .success(let records) = fetchResult {
			
			// Loop over all records
			for record in records {
				
				guard !record.error else { continue }
				
				let resources = record.resources.filter { resource in
					return resource.isReference(reference)
				}
				
				for resource in resources {
					if let uiSchema = FHIRParser().getDetails(resource) {
						return (resource, uiSchema)
					}
				}
			}
		}
		logDebug("Did not find a reference: \(reference)")
		return nil
	}
}
