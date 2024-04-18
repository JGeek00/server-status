import SwiftUI

struct MobileView: View {
    @EnvironmentObject var instancesModel: InstancesViewModel
    @EnvironmentObject var appConfig: AppConfigViewModel
    @EnvironmentObject var statusModel: StatusViewModel
    
    @State var showSystemInfoSheet = false
    
    var body: some View {
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
                GeometryReader { geometry in
                    let width =  geometry.size.width - 32
                    let gaugeSize = (geometry.size.width*0.5)/2
                    ScrollView {
                        VStack(alignment: .leading) {
                            if instancesModel.demoMode == true {
                                Text("Demo mode")
                                    .padding(.leading, 4)
                                    .foregroundColor(.gray)
                            }
                            if instancesModel.demoMode == false && instancesModel.selectedInstance != nil && appConfig.showUrlDetailsScreen {
                                Text(generateInstanceUrl(instance: instancesModel.selectedInstance!))
                                    .padding(.leading, 4)
                                    .foregroundColor(.gray)
                            }
                            Spacer().frame(height: 24)
                            CpuData(gaugeSize: gaugeSize)
                            Spacer().frame(height: 24)
                            Divider()
                            Spacer().frame(height: 24)
                            RamData(
                                gaugeSize: gaugeSize,
                                containerWidth: width
                            )
                            Spacer().frame(height: 24)
                            Divider()
                            Spacer().frame(height: 24)
                            StorageData(
                                gaugeSize: gaugeSize,
                                containerWidth: width
                            )
                            Spacer().frame(height: 24)
                            Divider()
                            Spacer().frame(height: 24)
                            NetworkData()
                            Spacer().frame(height: 24)
                        }
                        .padding(.horizontal, 16)
                    }
                    .refreshable {
                        guard let selectedInstance = instancesModel.selectedInstance else { return }
                        await statusModel.fetchStatus(
                            serverInstance: selectedInstance,
                            showError: false
                        )
                    }
                }
            }
        }
        .navigationTitle(instancesModel.selectedInstance?.name ?? "Server status")
        .toolbar(content: {
            ToolbarItem {
                HStack {
                    if statusModel.status?.isEmpty == false && statusModel.status?[0].host != nil {
                        Button {
                            showSystemInfoSheet.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .sheet(isPresented: $showSystemInfoSheet, content: {
                            DetailsSheet(hardwareItem: Enums.HardwareItem.systemInfo, onCloseSheet: { showSystemInfoSheet.toggle() })
                        })
                    }
                }
            }
        })
    }
}
