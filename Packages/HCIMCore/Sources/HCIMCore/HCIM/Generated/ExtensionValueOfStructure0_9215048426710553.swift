// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let extensionValueOfStructure09215048426710553 = try ExtensionValueOfStructure0_9215048426710553(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ExtensionValueOfStructure0_9215048426710553
public struct ExtensionValueOfStructure0_9215048426710553: Codable, Hashable, Sendable {
    public let ext: Bool
    public let accountNumber, bankcode, bankName: ExtensionValueOfMgoString?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case accountNumber, bankcode, bankName
    }

    public init(ext: Bool, accountNumber: ExtensionValueOfMgoString?, bankcode: ExtensionValueOfMgoString?, bankName: ExtensionValueOfMgoString?) {
        self.ext = ext
        self.accountNumber = accountNumber
        self.bankcode = bankcode
        self.bankName = bankName
    }
}

// MARK: ExtensionValueOfStructure0_9215048426710553 convenience initializers and mutators

public extension ExtensionValueOfStructure0_9215048426710553 {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExtensionValueOfStructure0_9215048426710553.self, from: data)
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
        accountNumber: ExtensionValueOfMgoString?? = nil,
        bankcode: ExtensionValueOfMgoString?? = nil,
        bankName: ExtensionValueOfMgoString?? = nil
    ) -> ExtensionValueOfStructure0_9215048426710553 {
        return ExtensionValueOfStructure0_9215048426710553(
            ext: ext ?? self.ext,
            accountNumber: accountNumber ?? self.accountNumber,
            bankcode: bankcode ?? self.bankcode,
            bankName: bankName ?? self.bankName
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
