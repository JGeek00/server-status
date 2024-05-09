import SwiftUI

struct ServersInstancesList: View {
    @EnvironmentObject var instancesModel: InstancesViewModel
    @ObservedObject var instanceFormModel: InstanceFormViewModel
    @ObservedObject var settingsModel: SettingsViewModel
    @EnvironmentObject var statusModel: StatusViewModel
    
    @AppStorage(StorageKeys.refreshTime, store: UserDefaults(suiteName: groupId)) private var refreshTime: String = "2"
    
    @FetchRequest(
        entity: ServerInstances.entity(),
        sortDescriptors: [],
        animation: .spring
    ) var instances: FetchedResults<ServerInstances>
    
    var body: some View {
        Section("Server instances") {
            ForEach(instances) {
                item in Button {
                    instancesModel.switchInstance(instance: item, statusModel: statusModel)
                } label: {
                    HStack {
                        HStack {
                            Image(systemName: "server.rack")
                                .foregroundColor(.foreground)
                            Spacer().frame(width: 16)
                            VStack(alignment: .leading) {
                                Text(item.name ?? "")
                                    .foregroundColor(.foreground)
                                Spacer().frame(height: 4)
                                Text(generateInstanceUrl(instance: item))
                                    .font(.system(size: 14))
                                    .foregroundColor(.foreground)
                            }
                            if item.id == instancesModel.selectedInstance?.id {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }.contextMenu(ContextMenu(menuItems: {
                        Section {
                            Button {
                                instancesModel.setDefaultInstance(instance: item)
                            } label: {
                                Label {
                                    Text(instancesModel.defaultServer == item.id ? "Default server" : "Set as default server")
                                } icon: {
                                    Image(systemName: "star")
                                }
                            }.disabled(instancesModel.defaultServer == item.id)
                        }
                        Section {
                            Button {
                                instanceFormModel.editId = item.id!
                                instanceFormModel.name = item.name ?? ""
                                instanceFormModel.connectionMethod = item.connectionMethod ?? ""
                                instanceFormModel.ipDomain = item.ipDomain ?? ""
                                instanceFormModel.port = item.port ?? ""
                                instanceFormModel.path = item.path ?? ""
                                instanceFormModel.useBasicAuth = item.useBasicAuth
                                instanceFormModel.basicAuthUser = item.basicAuthUser ?? ""
                                instanceFormModel.basicAuthPassword = item.basicAuthPassword ?? ""
                                instanceFormModel.modalOpen.toggle()
                            } label: {
                                Label {
                                    Text("Edit")
                                } icon: {
                                    Image(systemName: "pencil")
                                }
                            }
                            Button(role: .destructive) {
                                settingsModel.selectedItemDelete = item
                                settingsModel.confirmDeleteOpen.toggle()
                            } label: {
                                Label {
                                    Text("Delete")
                                } icon: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }))
                }
            }
            Button {
                instanceFormModel.reset()
                instanceFormModel.modalOpen.toggle()
            } label: {
                HStack {
                    Spacer().frame(width: 4)
                    Image(systemName: "plus")
                    Spacer().frame(width: 18)
                    Text("New instance")
                }
            }
        }
    }
}
