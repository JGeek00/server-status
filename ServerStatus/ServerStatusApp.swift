import SwiftUI
import Sentry

@main
struct ServerStatusApp: App {    
    let persistenceController = PersistenceController.shared
    let instancesViewModel = InstancesViewModel()
    let statusViewModel = StatusViewModel()
    let tipsViewModel = TipsViewModel()
    
    init() {
        startSentry()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.locale, .init(identifier: Locale.current.identifier))
                .environmentObject(instancesViewModel)
                .environmentObject(statusViewModel)
                .environmentObject(tipsViewModel)
        }
    }
}
