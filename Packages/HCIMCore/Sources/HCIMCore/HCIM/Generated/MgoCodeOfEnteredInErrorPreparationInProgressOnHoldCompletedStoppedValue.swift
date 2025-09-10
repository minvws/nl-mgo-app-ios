import Foundation

public enum MgoCodeOfEnteredInErrorPreparationInProgressOnHoldCompletedStoppedValue: String, Codable, Hashable, Sendable {
    case completed = "completed"
    case enteredInError = "entered-in-error"
    case inProgress = "in-progress"
    case onHold = "on-hold"
    case preparation = "preparation"
    case stopped = "stopped"
}
