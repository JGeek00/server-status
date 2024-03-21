import SwiftUI
import Sentry

@main
struct ServerStatusApp: App {    
    let persistenceController = PersistenceController.shared
    let instancesViewModel = InstancesViewModel()
    let appConfigViewModel = AppConfigViewModel()
    let statusViewModel = StatusViewModel()
    
    init() {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else { return }
        guard let configDict = NSDictionary(contentsOfFile: path) else { return }
        guard let dsn = configDict["SENTRY_DSN"] else { return }
        SentrySDK.start { options in
            options.dsn = dsn as? String
            options.debug = false
            options.enableTracing = false
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.locale, .init(identifier: Locale.current.identifier))
                .environmentObject(instancesViewModel)
                .environmentObject(appConfigViewModel)
                .environmentObject(statusViewModel)
        }
    }
}
