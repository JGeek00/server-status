import SwiftUI
import CoreData

struct RootView: View { 
    @EnvironmentObject var appConfig: AppConfigViewModel
    @EnvironmentObject var instancesModel: InstancesViewModel
    @StateObject var welcomeSheetModel = WelcomeSheetViewModel()
    @EnvironmentObject var statusModel: StatusViewModel
    
    @FetchRequest(
        entity: ServerInstances.entity(),
        sortDescriptors: [],
        animation: .spring
    ) var instances: FetchedResults<ServerInstances>
    
    var body: some View {
        TabView {
            NavigationStack {
                if instances.isEmpty && instancesModel.demoMode == false {
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
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(1)
        }
        .preferredColorScheme(appConfig.getTheme())
        .sheet(isPresented: $welcomeSheetModel.openSheet) {
            WelcomeSheetView(welcomeSheetModel: welcomeSheetModel)
        }
    }
}


#Preview {
    RootView()
}
