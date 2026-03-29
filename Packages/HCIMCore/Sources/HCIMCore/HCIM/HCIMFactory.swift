/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug
@_exported import HCIMCoreModels

/*
 Health and Care Information models (HCIM), or Clinical Buildingblocks (CBB's) or Zorginformatiebouwstenen (zib's)
 are used to capture functional, semantic (non technical) agreements for the standardization of information used in
 the care process. The purpose of the standardization is that this information from the care process is reused for
 other purposes such as quality registration, transfer or patient-related research.
 A HCIM is an information model in which a care-based concept is described in terms of the data elements from which
 that concept exists, the data types of those data elements, etc.
 
 See: https://zibs.nl/wiki/HCIM_Mainpage
 */
@MainActor
public class HCIMFactory {
	
	/// Create a Zib MedicationUse from a parsed resource
	/// See: https://zibs.nl/wiki/MedicationUse2-v1.0.1(2017EN)
	/// See: https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/2.2.18/files/2317279
	/// - Parameter data: the parsed resource
	/// - Returns: Zib Medication use
	public static func createZibMedicationUse(_ data: Data) -> ZibMedicationUse? {
		
		return decode(
			data: data,
			profileDefinition: ZibMedicationUseProfile.httpNictizNlFhirStructureDefinitionZibMedicationUse.rawValue
		)
	}
	
	/// Generic decode method to decode a parsed resource into a HCIM
	/// - Parameters:
	///   - data: the mgo resource
	///   - profileDefinition: the factory will only decode data that has this profile definition
	/// - Returns: Health and Care Information model
	private static func decode<T: Decodable>(data: Data, profileDefinition: String) -> T? {
		
//		logDebug("HCIMFactory: trying to decoding \(String(decoding: data, as: UTF8.self))")
		guard data.hasProfile(profileDefinition) else { return nil }
		
		do {
			let hcim = try JSONDecoder().decode(T.self, from: data)
			return hcim
		} catch {
			logError("HCIMFactory: error decoding for \(profileDefinition): \(error)")
		}
		return nil
	}
}
