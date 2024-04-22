import Foundation

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults(suiteName: "group.com.jgeek00.ServerStatus")
    
    private init() {}
    
    func saveValue(_ value: String, forKey key: String) {
        defaults?.setValue(value, forKey: key)
    }
    
    func getValue(forKey key: String) -> String? {
        return defaults?.string(forKey: key)
    }
}
