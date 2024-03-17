import SwiftUI

@main
struct ServerStatusApp: App {    
    let persistenceController = PersistenceController.shared
    let appConfigViewModel = AppConfigViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.locale, .init(identifier: "en"))
                .environment(\.locale, .init(identifier: "es"))
                .environmentObject(appConfigViewModel)
        }
    }
}
