import SwiftUI
import CoreData

struct RootView: View { 
    @EnvironmentObject var appConfig: AppConfigViewModel
    
    var body: some View {
        NavigationView {
            NoInstancesView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(appConfig.getTheme())
    }
}


#Preview {
    RootView()
}
