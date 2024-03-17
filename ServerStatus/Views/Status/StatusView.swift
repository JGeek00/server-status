import SwiftUI

struct StatusView: View {
    @EnvironmentObject var instancesModel: InstancesViewModel
    @StateObject var settingsModel = SettingsViewModel()
    
    var body: some View {
        ScrollView {
            Text(instancesModel.selectedInstance?.id ?? "")
        }
        .navigationTitle("Server status")
        .toolbar(content: {
            ToolbarItem {
                Button {
                    settingsModel.modalOpen.toggle()
                } label: {
                    Image(systemName: "gear")
                }
            }
        })
        .sheet(isPresented: $settingsModel.modalOpen, content: {
            SettingsView(settingsModel: settingsModel)
        })
    }
}

#Preview {
    StatusView()
}
