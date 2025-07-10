// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let bankInformation = try BankInformation(json)
//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - BankInformation
public struct BankInformation: Codable, Hashable, Sendable {
    public let ext: Bool
    public let accountNumber: AccountNumber?
    public let bankcode: Bankcode?
    public let bankName: BankName?

    public enum CodingKeys: String, CodingKey {
        case ext = "_ext"
        case accountNumber, bankcode, bankName
    }

    public init(ext: Bool, accountNumber: AccountNumber?, bankcode: Bankcode?, bankName: BankName?) {
        self.ext = ext
        self.accountNumber = accountNumber
        self.bankcode = bankcode
        self.bankName = bankName
    }
}

// MARK: BankInformation convenience initializers and mutators

public extension BankInformation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(BankInformation.self, from: data)
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
        accountNumber: AccountNumber?? = nil,
        bankcode: Bankcode?? = nil,
        bankName: BankName?? = nil
    ) -> BankInformation {
        return BankInformation(
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
