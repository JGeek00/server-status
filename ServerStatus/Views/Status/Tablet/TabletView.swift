import SwiftUI

struct TabletView: View {
    @EnvironmentObject var instancesModel: InstancesViewModel
    @EnvironmentObject var appConfig: AppConfigViewModel
    @EnvironmentObject var statusModel: StatusViewModel
    @StateObject var settingsModel = SettingsViewModel()
    
    var body: some View {
        let data = statusModel.status?.last
        let previous = statusModel.status != nil ? statusModel.status!.count > 1 ? statusModel.status![statusModel.status!.count-2] : nil : nil
        
        let cpuMaxTemp = data?.cpu?.temperatures?.map({ return $0.first ?? 0 }).max()
        
        func getMemoryValue() -> String {
            guard let total = data?.memory?.total else { return "N/A" }
            guard let available = data?.memory?.available else { return "N/A" }
            let memoryUsed = total - available
            let memoryPerc = (Double(memoryUsed)/Double(total))*100.0
            return "\(Int(memoryPerc))%"
        }
        
        func getStorageValue() -> String {
            guard let available = data?.storage?.home?.available else { return "N/A" }
            guard let total = data?.storage?.home?.total else { return "N/A" }
            let percent = 100.0-((Double(available)/Double(total))*100.0)
            return "\(Int(percent))%"
        }
        
        func getDownloadValue() -> String {
            guard let current = data?.network?.rx else { return "N/A" }
            guard let previous = previous?.network?.rx else { return "N/A" }
            return formatBits(value: abs(current - previous))
        }
        
        func getUploadValue() -> String {
            guard let current = data?.network?.tx else { return "N/A" }
            guard let previous = previous?.network?.tx else { return "N/A" }
            return formatBits(value: abs(current - previous))
        }
        
        return NavigationSplitView {
            VStack {
                if statusModel.initialLoading == true {
                    VStack {
                        ProgressView()
                    }
                }
                else if statusModel.loadError == true {
                    VStack {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 40))
                        Spacer().frame(height: 20)
                        Text("An error occured while loading the data.")
                            .font(.system(size: 24))
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: 40)
                        Button {
                            guard let selectedInstance = instancesModel.selectedInstance else { return }
                            Task { await statusModel.fetchStatus(serverInstance: selectedInstance, showError: true) }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Retry")
                            }
                        }
                    }.padding(.horizontal, 24)
                }
                else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            if instancesModel.demoMode == true {
                                Text("Demo mode")
                                    .padding(.leading, 17)
                                    .padding(.bottom, 8)
                                    .foregroundColor(.gray)
                            }
                            if instancesModel.demoMode == false && instancesModel.selectedInstance != nil && appConfig.showUrlDetailsScreen {
                                Text(generateInstanceUrl(instance: instancesModel.selectedInstance!))
                                    .padding(.leading, 17)
                                    .padding(.bottom, 8)
                                    .foregroundColor(.gray)
                            }
                            TabletViewHardwareEntry(
                                image: "cpu",
                                label: "CPU",
                                hardwareItem: Enums.HardwareItem.cpu,
                                value1: data?.cpu?.utilisation != nil ? "\(String(describing: Int(data!.cpu!.utilisation!*100)))%" : "N/A",
                                value1Image: "cpu",
                                value2: cpuMaxTemp != nil ? "\(String(describing: cpuMaxTemp!))ºC" : "N/A",
                                value2Image: "thermometer.medium"
                            )
                            Divider()
                            TabletViewHardwareEntry(
                                image: "memorychip",
                                label: "Memory",
                                hardwareItem: Enums.HardwareItem.memory,
                                value1: getMemoryValue(),
                                value1Image: "memorychip",
                                value2: nil,
                                value2Image: nil
                            )
                            Divider()
                            TabletViewHardwareEntry(
                                image: "internaldrive",
                                label: "Storage",
                                hardwareItem: Enums.HardwareItem.storage,
                                value1: getStorageValue(),
                                value1Image: "internaldrive",
                                value2: nil,
                                value2Image: nil
                            )
                            Divider()
                            TabletViewHardwareEntry(
                                image: "network",
                                label: "Network",
                                hardwareItem: Enums.HardwareItem.network,
                                value1: getDownloadValue(),
                                value1Image: "arrow.down.circle",
                                value2: getUploadValue(),
                                value2Image: "arrow.up.circle"
                            )
                        }
                    }
                }
            }
            .navigationTitle(instancesModel.selectedInstance?.name ?? "Server status")
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
        } detail: {
            Text(statusModel.selectedHardwareItem?.rawValue ?? "Not selected")
        }
    }
}
