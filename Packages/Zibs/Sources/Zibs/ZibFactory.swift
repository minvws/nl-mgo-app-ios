/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Logging

public class ZibFactory {
	
	/// Create a Zib MedicationUse from a parsed resource
	/// - Parameter data: the parsed resource
	/// - Returns: Zib Medication use
	public static func createZibMedicationUse(_ data: Data) -> ZibMedicationUse? {
		
		return decode(
			data: data,
			profileDefinition: ZibMedicationUseProfile.httpNictizNlFhirStructureDefinitionZibMedicationUse.rawValue
		)
	}
	
	/// Create a Zib Product from a parsed resource
	/// - Parameter data: the parsed resource
	/// - Returns: Zib Product
	public static func createZibProduct(_ data: Data) -> ZibProduct? {
		
		return decode(
			data: data,
			profileDefinition: ZibProductProfile.httpNictizNlFhirStructureDefinitionZibProduct.rawValue
		)
	}
	
	/// Generic decode method to decode a parsed resource into a zib
	/// - Parameters:
	///   - data: the parsed resource
	///   - profileDefinition: the profile definition
	/// - Returns: zib
	private static func decode<T: Decodable>(data: Data, profileDefinition: String) -> T? {
		
//		logDebug("ZibFactory: trying to decoding \(String(decoding: data, as: UTF8.self))")
		guard data.hasProfile(profileDefinition) else { return nil }
		
		do {
			let zib = try JSONDecoder().decode(T.self, from: data)
			return zib
		} catch {
			logError("ZibFactory: error decoding for \(profileDefinition): \(error)")
		}
		return nil
	}
}
