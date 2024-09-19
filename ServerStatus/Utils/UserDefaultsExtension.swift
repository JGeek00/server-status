import Foundation

@MainActor
public extension UserDefaults {
    static let shared = UserDefaults(suiteName: groupId)!
}
