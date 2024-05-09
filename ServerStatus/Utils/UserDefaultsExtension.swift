import Foundation

public extension UserDefaults {
    static let shared = UserDefaults(suiteName: groupId)!
}
