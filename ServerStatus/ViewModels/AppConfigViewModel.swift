import Foundation
import Combine
import SwiftUI

class AppConfigViewModel: ObservableObject {
    @Published var theme: Enums.Theme = Enums.Theme.system
    @Published var showUrlDetailsScreen = true
    @Published var refreshTime: Double = 2.0
    
    init() {
        let userDefaults = UserDefaults(suiteName: groupId)
        let storageTheme = userDefaults?.object(forKey: StorageKeys.theme) as? String
        if storageTheme != nil {
            self.theme = Enums.Theme(stringValue: storageTheme!) ?? Enums.Theme.system
        }
        showUrlDetailsScreen = userDefaults?.object(forKey: StorageKeys.showServerUrlDetails) as? Bool ?? true
        refreshTime = userDefaults?.double(forKey: StorageKeys.refreshTime) ?? 2.0
    }
    
    func updateTheme(selectedTheme: Enums.Theme) {
        theme = selectedTheme
        UserDefaults(suiteName: groupId)?.setValue(selectedTheme.rawValue, forKey: StorageKeys.theme)
    }
    
    func updateSettingsToggle(key: String, value: Bool) {
        UserDefaults(suiteName: groupId)?.setValue(value, forKey: key)
    }
    
    func updateRefreshTime(value: Double) {
        UserDefaults(suiteName: groupId)?.setValue(value, forKey: StorageKeys.refreshTime)
    }
    
    func getTheme() -> ColorScheme {
        switch theme {
            case Enums.Theme.system:
                return UIScreen.main.traitCollection.userInterfaceStyle == .dark ? ColorScheme.dark : ColorScheme.light
            case Enums.Theme.light:
                return .light
            case Enums.Theme.dark:
                return .dark
        }
    }
}
