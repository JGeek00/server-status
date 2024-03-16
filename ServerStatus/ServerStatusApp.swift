//
//  ServerStatusApp.swift
//  ServerStatus
//
//  Created by Juan Gilsanz Polo on 17/3/24.
//

import SwiftUI

@main
struct ServerStatusApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
