import Combine
import Foundation

class WelcomeSheetViewModel: ObservableObject {
    @Published var openSheet = false
    
    init() {
        let dismissed = UserDefaults.standard.object(forKey: StorageKeys.welcomeSheetDismissed) as? Bool
        if dismissed == nil {
            openSheet = true
        }
    }
    
    func dismissSheet() {
        openSheet = false
        UserDefaults.standard.setValue(true, forKey: StorageKeys.welcomeSheetDismissed)
    }
}
