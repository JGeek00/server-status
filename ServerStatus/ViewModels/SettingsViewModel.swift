import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var modalOpen = false
    @Published var statusRepoSafariOpen = false
    @Published var contactDeveloperSafariOpen = false
    @Published var confirmDeleteOpen = false
    @Published var selectedItemDelete: ServerInstances?
}
