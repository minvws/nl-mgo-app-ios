// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let focalDevice = try FocalDevice(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - FocalDevice
public struct FocalDevice: Codable, Hashable, Sendable {
    public let manipulated: MgoReference?

    public init(manipulated: MgoReference?) {
        self.manipulated = manipulated
    }
}

// MARK: FocalDevice convenience initializers and mutators

public extension FocalDevice {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FocalDevice.self, from: data)
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
        manipulated: MgoReference?? = nil
    ) -> FocalDevice {
        return FocalDevice(
            manipulated: manipulated ?? self.manipulated
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
