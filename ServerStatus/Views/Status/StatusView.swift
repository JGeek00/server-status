import SwiftUI

struct StatusView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @EnvironmentObject var instancesProvider: InstancesProvider
    @EnvironmentObject var statusProvider: StatusProvider
    
    @AppStorage(StorageKeys.refreshTime, store: UserDefaults.shared) private var refreshTime: String = "2"
    
    var body: some View {
        VStack {
            if horizontalSizeClass == .regular {
                TabletView()
            }
            else {
                MobileView()
            }
        }
        .onAppear(perform: {
            statusProvider.startTimer(interval: refreshTime)
        })
    }
}

#Preview {
    StatusView()
}
