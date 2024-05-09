import SwiftUI

struct StatusView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @EnvironmentObject var instancesModel: InstancesViewModel
    @EnvironmentObject var statusModel: StatusViewModel
    
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
            guard let selectedInstance = instancesModel.selectedInstance else { return }
            statusModel.startTimer(serverInstance: selectedInstance, interval: refreshTime)
        })
    }
}

#Preview {
    StatusView()
}
