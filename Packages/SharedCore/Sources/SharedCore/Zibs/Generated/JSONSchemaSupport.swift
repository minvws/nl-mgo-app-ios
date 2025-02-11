import Foundation

public typealias MgoString = String
public typealias MgoUnsignedInt = Double
public typealias MgoDateTime = String
public typealias DateTimeString = String
public typealias MgoBoolean = Bool
public typealias MgoDate = String
public typealias DateString = String
public typealias MgoDecimal = Double
public typealias MgoInstant = String
public typealias InstantDateTimeString = String
public typealias MgoInteger = Double
public typealias MgoInteger64 = Double
public typealias MgoPositiveInt = Double
public typealias MgoCode = String

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
