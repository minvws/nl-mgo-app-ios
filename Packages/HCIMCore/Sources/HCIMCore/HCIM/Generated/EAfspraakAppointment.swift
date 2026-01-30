// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eAfspraakAppointment = try EAfspraakAppointment(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - EAfspraakAppointment
public struct EAfspraakAppointment: Codable, Hashable, Sendable {
    public let appointmentType: MgoCodeableConcept?
    public let created: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let description: PrimitiveValueTypeOfStringString?
    public let end: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let fhirVersion: NlCoreObservationFhirVersion
    public let id: String?
    public let identifier: [MgoIdentifier]?
    public let incomingReferral, indication: [MgoReference]?
    public let minutesDuration: MgoPositiveInt?
    public let onlineEditable: ExtensionValueOfStructure0_8003184466349818?
    public let participant: [EAfspraakAppointmentParticipant]?
    public let patientInstructions: [ExtensionValueOfMgoString]
    public let profile: EAfspraakAppointmentProfile
    public let reason: [MgoCodeableConcept]?
    public let referenceID, resourceType: String
    public let serviceCategory: MgoCodeableConcept?
    public let specialty: [MgoCodeableConcept]?
    public let start: PrimitiveValueTypeOfDateTimeDateTimeString?
    public let status: EAfspraakAppointmentStatus

    public enum CodingKeys: String, CodingKey {
        case appointmentType, created, description, end, fhirVersion, id, identifier, incomingReferral, indication, minutesDuration, onlineEditable, participant, patientInstructions, profile, reason
        case referenceID = "referenceId"
        case resourceType, serviceCategory, specialty, start, status
    }

    public init(appointmentType: MgoCodeableConcept?, created: PrimitiveValueTypeOfDateTimeDateTimeString?, description: PrimitiveValueTypeOfStringString?, end: PrimitiveValueTypeOfDateTimeDateTimeString?, fhirVersion: NlCoreObservationFhirVersion, id: String?, identifier: [MgoIdentifier]?, incomingReferral: [MgoReference]?, indication: [MgoReference]?, minutesDuration: MgoPositiveInt?, onlineEditable: ExtensionValueOfStructure0_8003184466349818?, participant: [EAfspraakAppointmentParticipant]?, patientInstructions: [ExtensionValueOfMgoString], profile: EAfspraakAppointmentProfile, reason: [MgoCodeableConcept]?, referenceID: String, resourceType: String, serviceCategory: MgoCodeableConcept?, specialty: [MgoCodeableConcept]?, start: PrimitiveValueTypeOfDateTimeDateTimeString?, status: EAfspraakAppointmentStatus) {
        self.appointmentType = appointmentType
        self.created = created
        self.description = description
        self.end = end
        self.fhirVersion = fhirVersion
        self.id = id
        self.identifier = identifier
        self.incomingReferral = incomingReferral
        self.indication = indication
        self.minutesDuration = minutesDuration
        self.onlineEditable = onlineEditable
        self.participant = participant
        self.patientInstructions = patientInstructions
        self.profile = profile
        self.reason = reason
        self.referenceID = referenceID
        self.resourceType = resourceType
        self.serviceCategory = serviceCategory
        self.specialty = specialty
        self.start = start
        self.status = status
    }
}

// MARK: EAfspraakAppointment convenience initializers and mutators

public extension EAfspraakAppointment {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EAfspraakAppointment.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        appointmentType: MgoCodeableConcept?? = nil,
        created: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        description: PrimitiveValueTypeOfStringString?? = nil,
        end: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        fhirVersion: NlCoreObservationFhirVersion? = nil,
        id: String?? = nil,
        identifier: [MgoIdentifier]?? = nil,
        incomingReferral: [MgoReference]?? = nil,
        indication: [MgoReference]?? = nil,
        minutesDuration: MgoPositiveInt?? = nil,
        onlineEditable: ExtensionValueOfStructure0_8003184466349818?? = nil,
        participant: [EAfspraakAppointmentParticipant]?? = nil,
        patientInstructions: [ExtensionValueOfMgoString]? = nil,
        profile: EAfspraakAppointmentProfile? = nil,
        reason: [MgoCodeableConcept]?? = nil,
        referenceID: String? = nil,
        resourceType: String? = nil,
        serviceCategory: MgoCodeableConcept?? = nil,
        specialty: [MgoCodeableConcept]?? = nil,
        start: PrimitiveValueTypeOfDateTimeDateTimeString?? = nil,
        status: EAfspraakAppointmentStatus? = nil
    ) -> EAfspraakAppointment {
        return EAfspraakAppointment(
            appointmentType: appointmentType ?? self.appointmentType,
            created: created ?? self.created,
            description: description ?? self.description,
            end: end ?? self.end,
            fhirVersion: fhirVersion ?? self.fhirVersion,
            id: id ?? self.id,
            identifier: identifier ?? self.identifier,
            incomingReferral: incomingReferral ?? self.incomingReferral,
            indication: indication ?? self.indication,
            minutesDuration: minutesDuration ?? self.minutesDuration,
            onlineEditable: onlineEditable ?? self.onlineEditable,
            participant: participant ?? self.participant,
            patientInstructions: patientInstructions ?? self.patientInstructions,
            profile: profile ?? self.profile,
            reason: reason ?? self.reason,
            referenceID: referenceID ?? self.referenceID,
            resourceType: resourceType ?? self.resourceType,
            serviceCategory: serviceCategory ?? self.serviceCategory,
            specialty: specialty ?? self.specialty,
            start: start ?? self.start,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
