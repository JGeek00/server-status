import SwiftUI
import CoreData

struct RootView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var scheme
    
    @AppStorage(StorageKeys.theme, store: UserDefaults.shared) private var theme: Enums.Theme = .system
    
    @FetchRequest(
        entity: ServerInstances.entity(),
        sortDescriptors: [],
        animation: .spring
    ) private var instances: FetchedResults<ServerInstances>
    
    @EnvironmentObject private var welcomeSheetViewModel: WelcomeSheetViewModel
    
    var body: some View {
        if horizontalSizeClass == .regular {
            Group {
                if instances.isEmpty {
                    NoInstancesView()
                }
                else {
                    StatusView()
                }
            }
            .preferredColorScheme(getColorScheme(theme: theme))
            .sheet(isPresented: $welcomeSheetViewModel.openSheet) {
                WelcomeSheetView()
            }
        }
        else {
            TabView {
                NavigationStack {
                    if instances.isEmpty {
                        NoInstancesView()
                    }
                    else {
                        StatusView()
                    }
                }
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Status")
                }
                .tag(0)
                SettingsView(scheme: scheme, onCloseSheet: nil)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(1)
            }
            .preferredColorScheme(getColorScheme(theme: theme))
            .sheet(isPresented: $welcomeSheetViewModel.openSheet) {
                WelcomeSheetView()
            }
        }
    }
}


#Preview {
    RootView()
}
