import SwiftUI

struct ServerInstanceItem: View {
    var instance: ServerInstances
    
    init(instance: ServerInstances) {
        self.instance = instance
    }
    
    @EnvironmentObject private var instancesProvider: InstancesProvider
    
    @State private var editInstanceFormSheet = false
    @State private var deleteInstanceAlert = false
    
    var body: some View {
        Button {
            instancesProvider.switchInstance(instance: instance)
        } label: {
            HStack {
                HStack {
                    Image(systemName: "server.rack")
                        .foregroundColor(.foreground)
                    Spacer().frame(width: 16)
                    VStack(alignment: .leading) {
                        Text(instance.name ?? "")
                            .foregroundColor(.foreground)
                        Spacer().frame(height: 4)
                        Text(generateInstanceUrl(instance: instance))
                            .font(.system(size: 14))
                            .foregroundColor(.foreground)
                    }
                    if instance.id == instancesProvider.selectedInstance?.id {
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .contextMenu(ContextMenu(menuItems: {
                Section {
                    Button {
                        instancesProvider.setDefaultInstance(instance: instance)
                    } label: {
                        Label {
                            Text(instancesProvider.defaultServer == instance.id ? "Default server" : "Set as default server")
                        } icon: {
                            Image(systemName: "star")
                        }
                    }
                    .disabled(instancesProvider.defaultServer == instance.id)
                }
                Section {
                    Button {
                        editInstanceFormSheet = true
                    } label: {
                        Label {
                            Text("Edit")
                        } icon: {
                            Image(systemName: "pencil")
                        }
                    }
                    Button(role: .destructive) {
                        deleteInstanceAlert = true
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
        .sheet(isPresented: $editInstanceFormSheet, content: {
            InstanceFormView(instance: instance) {
                editInstanceFormSheet = false
            }
        })
        .alert("Delete instance", isPresented: $deleteInstanceAlert, actions: {
            Button(role: .destructive) {
                instancesProvider.deleteInstance(instance: instance)
            } label: {
                Text("Delete")
            }
        }, message: {
            Text("Are you sure you want to delete this instance?")
        })
    }
}
