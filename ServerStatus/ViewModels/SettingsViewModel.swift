import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var modalOpen = false
    @Published var safariOpen = false
    @Published var confirmDeleteOpen = false
    @Published var selectedItemDelete: ServerInstances?
}
