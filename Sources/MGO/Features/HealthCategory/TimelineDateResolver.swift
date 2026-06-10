/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

/// A type that exposes a single representative date for ordering items on a timeline.
///
/// Different FHIR profiles expose their date under different property paths
/// (e.g. `indexed.date` vs `date.date`). Conforming types adapt those
/// profile-specific shapes to one uniform `timelineDate`, so timeline UI can
/// sort and group records without knowing about the source profile.
protocol TimelineDateResolver {
	/// The date used to position the record on a timeline, or `nil` when the
	/// source record does not carry a date.
	var timelineDateValue: Date? { get }
}

/// Builds a `TimelineDateResolver` from a raw FHIR payload, dispatched on the
/// FHIR profile URL.
///
/// The factory owns a registry that maps each supported profile URL to the
/// corresponding `HCIMFactory` builder. Callers pass the profile URL declared
/// by the resource's `meta.profile` along with the raw `Data`; the factory
/// returns `nil` when the profile is not registered or the payload fails to
/// decode.
///
/// Marked `@MainActor` because the underlying `HCIMFactory` builders are
/// main-actor isolated.
@MainActor
enum TimelineDateResolversMap {
	/// Maps a FHIR profile URL to a closure that decodes the payload into a
	/// concrete `TimelineDateResolver`. Add a new entry here when introducing
	/// support for an additional profile.
	private static let registry: [String: (Data) -> (any TimelineDateResolver)?] = [
		IheMhdMinimalDocumentReferenceProfile.httpNictizNlFhirStructureDefinitionIHEMHDMinimalDocumentReference.rawValue:
			{ HCIMFactory.createIheMhdMinimalDocumentReference($0) },
		R4BBSDocumentReferenceProfile.httpMedmijNlFhirStructureDefinitionBBSDocumentReference.rawValue:
			{ HCIMFactory.createR4BBSDocumentReference($0) }
	]

	/// Decodes `data` into a `TimelineDateResolver` for the given FHIR `profile`
	/// URL, or returns `nil` if the profile is unsupported or decoding fails.
	static func make(profile: String, data: Data) -> (any TimelineDateResolver)? {
		registry[profile]?(data)
	}
}

extension IheMhdMinimalDocumentReference: TimelineDateResolver {
	var timelineDateValue: Date? { indexed?.date }
}

extension R4BBSDocumentReference: TimelineDateResolver {
	var timelineDateValue: Date? { date?.date }
}
