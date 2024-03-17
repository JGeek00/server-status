import SwiftUI
import CoreData

struct RootView: View { 
    @EnvironmentObject var appConfig: AppConfigViewModel
    @EnvironmentObject var instancesModel: InstancesViewModel
    
    @FetchRequest(
        entity: ServerInstances.entity(),
        sortDescriptors: [],
        animation: .spring
    ) var instances: FetchedResults<ServerInstances>
    
    var body: some View {
        NavigationView {
            if instances.isEmpty {
                NoInstancesView()
            }
            else {
                StatusView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(appConfig.getTheme())
    }
}


#Preview {
    RootView()
}
