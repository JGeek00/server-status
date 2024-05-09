import Foundation
import SwiftUI

func getColorScheme(theme: Enums.Theme) -> ColorScheme? {
    switch theme {
        case .system:
            return nil
        case .light:
            return ColorScheme.light
        case .dark:
            return ColorScheme.dark
    }
}

func getRefreshTime() -> String {
    let userDefaults = UserDefaults(suiteName: groupId)
    return userDefaults?.string(forKey: StorageKeys.refreshTime) ?? "2"
}
