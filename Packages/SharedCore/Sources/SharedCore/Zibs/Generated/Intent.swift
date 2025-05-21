import Foundation

public enum Intent: String, Codable, Hashable, Sendable {
    case instanceOrder = "instance-order"
    case order = "order"
    case plan = "plan"
    case proposal = "proposal"
}
