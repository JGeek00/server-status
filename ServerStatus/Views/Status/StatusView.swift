import SwiftUI

struct StatusView: View {
    @EnvironmentObject var instancesModel: InstancesViewModel
    @StateObject var settingsModel = SettingsViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var appConfig: AppConfigViewModel
    @StateObject var statusModel = StatusViewModel()
    
    var body: some View {
        VStack {
            if statusModel.initialLoading {
                VStack {
                    ProgressView()
                }
            }
            else if statusModel.loadError {
                VStack {
                    Image(systemName: "exclamationmark.circle")
                }
            }
            else {
                ScrollView {
//                    Text(instancesModel.selectedInstance?.id ?? "")
                    if horizontalSizeClass == .regular {
                        TabletView(
                            instancesModel: _instancesModel,
                            appConfig: _appConfig, 
                            statusModel: statusModel
                        )
                    }
                    else {
                        MobileView(
                            instancesModel: _instancesModel,
                            appConfig: _appConfig,
                            statusModel: statusModel
                        )
                    }
                }
                .refreshable {
                    guard let selectedInstance = instancesModel.selectedInstance else { return }
                    await statusModel.fetchStatus(serverInstance: selectedInstance)
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
        .onAppear(perform: {
            guard let selectedInstance = instancesModel.selectedInstance else { return }
            Task { await statusModel.fetchStatus(serverInstance: selectedInstance) }
        })
    }
}

private struct MobileView: View {
    @EnvironmentObject var instancesModel: InstancesViewModel
    @EnvironmentObject var appConfig: AppConfigViewModel
    @StateObject var statusModel: StatusViewModel
    
    var body: some View {
        let width =  UIScreen.main.bounds.width - 32
        let gaugeSize = (UIScreen.main.bounds.width*0.5)/2
        VStack(alignment: .leading) {
            if instancesModel.selectedInstance != nil && appConfig.showUrlDetailsScreen {
                Text(generateInstanceUrl(instance: instancesModel.selectedInstance!))
                    .padding(.leading, 8)
                    .foregroundColor(.gray)
            }
            Spacer().frame(height: 24)
            CpuData(gaugeSize: gaugeSize, statusModel: statusModel)
            Spacer().frame(height: 24)
            Divider()
            Spacer().frame(height: 24)
            RamData(
                gaugeSize: gaugeSize,
                containerWidth: width,
                statusView: statusModel
            )
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

private struct TabletView: View {
    @EnvironmentObject var instancesModel: InstancesViewModel
    @EnvironmentObject var appConfig: AppConfigViewModel
    @StateObject var statusModel: StatusViewModel
    
    var body: some View {
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
                CpuData(gaugeSize: gaugeSize, statusModel: statusModel)
                    .padding(.trailing, 16.0)
                RamData(
                    gaugeSize: gaugeSize, 
                    containerWidth: width,
                    statusView: statusModel
                )
                    .padding(.leading, 16.0)
                StorageData(gaugeSize: gaugeSize, containerWidth: width)
                    .padding(.trailing, 16.0)
                NetworkData()
                    .padding(.leading, 16.0)
            }
            .padding()
        }
    }
}

#Preview {
    StatusView()
}
