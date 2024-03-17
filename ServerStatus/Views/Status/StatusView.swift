import SwiftUI

struct StatusView: View {
    @EnvironmentObject var instancesModel: InstancesViewModel
    @StateObject var settingsModel = SettingsViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var appConfig: AppConfigViewModel
    
    var body: some View {
        ScrollView {
//            Text(instancesModel.selectedInstance?.id ?? "")
            if horizontalSizeClass == .regular {
                let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
                let width = (UIScreen.main.bounds.width - 64)/2
                let gaugeSize = ((UIScreen.main.bounds.width/2)*0.5)/2
                VStack(alignment: .leading) {
                    if instancesModel.selectedInstance != nil && appConfig.showUrlDetailsScreen {
                        Text(generateInstanceUrl(instance: instancesModel.selectedInstance!))
                            .padding(.leading, 20)
                            .foregroundColor(.gray)
                    }
                    LazyVGrid(columns: columns, spacing: width*0.2) {
                        CpuData(gaugeSize: gaugeSize)
                            .padding(.trailing, 16.0)
                        RamData(gaugeSize: gaugeSize, containerWidth: width)
                            .padding(.leading, 16.0)
                        StorageData(gaugeSize: gaugeSize, containerWidth: width)
                            .padding(.trailing, 16.0)
                        NetworkData()
                            .padding(.leading, 16.0)
                    }
                    .padding()
                }
            }
            else {
                let width =  UIScreen.main.bounds.width - 32
                let gaugeSize = (UIScreen.main.bounds.width*0.5)/2
                VStack(alignment: .leading) {
                    if instancesModel.selectedInstance != nil && appConfig.showUrlDetailsScreen {
                        Text(generateInstanceUrl(instance: instancesModel.selectedInstance!))
                            .padding(.leading, 8)
                            .foregroundColor(.gray)
                    }
                    Spacer().frame(height: 24)
                    CpuData(gaugeSize: gaugeSize)
                    Spacer().frame(height: 24)
                    Divider()
                    Spacer().frame(height: 24)
                    RamData(gaugeSize: gaugeSize, containerWidth: width)
                    Spacer().frame(height: 24)
                    Divider()
                    Spacer().frame(height: 24)
                    StorageData(gaugeSize: gaugeSize, containerWidth: width)
                    Spacer().frame(height: 24)
                    Divider()
                    Spacer().frame(height: 24)
                    NetworkData()
                    Spacer().frame(height: 24)
                }
                .padding(.horizontal, 16)
            }
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
