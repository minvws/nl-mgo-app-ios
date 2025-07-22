// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let verification = try Verification(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - Verification
public struct Verification: Codable, Hashable, Sendable {
    public let ext: Bool
    public let verificationDate: VerificationDate?
    public let verified: Verified?
    public let verifiedWith: VerifiedWith?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case verificationDate, verified, verifiedWith
    }

    public init(ext: Bool, verificationDate: VerificationDate?, verified: Verified?, verifiedWith: VerifiedWith?) {
        self.ext = ext
        self.verificationDate = verificationDate
        self.verified = verified
        self.verifiedWith = verifiedWith
    }
}

// MARK: Verification convenience initializers and mutators

public extension Verification {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Verification.self, from: data)
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
        ext: Bool? = nil,
        verificationDate: VerificationDate?? = nil,
        verified: Verified?? = nil,
        verifiedWith: VerifiedWith?? = nil
    ) -> Verification {
        return Verification(
            ext: ext ?? self.ext,
            verificationDate: verificationDate ?? self.verificationDate,
            verified: verified ?? self.verified,
            verifiedWith: verifiedWith ?? self.verifiedWith
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
