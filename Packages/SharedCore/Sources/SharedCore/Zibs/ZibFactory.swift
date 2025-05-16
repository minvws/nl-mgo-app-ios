/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug

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
	
	/// Generic decode method to decode a parsed resource into a Mgo Resource
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
