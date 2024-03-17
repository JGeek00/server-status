import Foundation
import Combine
import SwiftUI

class AppConfigViewModel: ObservableObject {
    @Published var theme: Enums.Theme = Enums.Theme.system
    @Published var showUrlDetailsScreen = true
    
    init() {
        let storageTheme = UserDefaults.standard.object(forKey: StorageKeys.theme) as? String
        if storageTheme != nil {
            self.theme = Enums.Theme(stringValue: storageTheme!) ?? Enums.Theme.system
        }
        showUrlDetailsScreen = UserDefaults.standard.object(forKey: StorageKeys.showServerUrlDetails) as? Bool ?? true
    }
    
    func updateTheme(selectedTheme: Enums.Theme) {
        theme = selectedTheme
        UserDefaults.standard.setValue(selectedTheme.rawValue, forKey: StorageKeys.theme)
    }
    
    func updateSettingsToggle(key: String, value: Bool) {
        UserDefaults.standard.setValue(value, forKey: key)
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
