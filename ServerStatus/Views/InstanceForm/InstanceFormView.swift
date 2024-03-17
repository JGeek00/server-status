import SwiftUI

struct InstanceFormView: View {
    @ObservedObject var instanceFormModel: InstanceFormViewModel
    @EnvironmentObject var instancesModel: InstancesViewModel
    
    @FetchRequest(
        entity: ServerInstances.entity(),
        sortDescriptors: [],
        animation: .spring
    ) var instances: FetchedResults<ServerInstances>
    
    func generateInstanceUrl() -> String {
        return "\(String(instanceFormModel.connectionMethod).lowercased())://\(instanceFormModel.ipDomain)\(instanceFormModel.port != "" ? ":\(instanceFormModel.port)" : "")\(instanceFormModel.path)"
    }
    
    var body: some View {
        let validValues = instanceFormModel.name != "" && instanceFormModel.ipDomainValid && instanceFormModel.portValid && instanceFormModel.pathValid && ((instanceFormModel.useBasicAuth && instanceFormModel.basicAuthUser != "" && instanceFormModel.basicAuthPassword != "") || !instanceFormModel.useBasicAuth)
        let url = generateInstanceUrl()
        NavigationView {
            Form {
                List {
                    Section() {
                        Text(url != "" ? url : "Instance URL")
                            .foregroundColor(url != "" ? .blue : .gray)
                        
                        HStack {
                            Image(systemName: validValues ? "checkmark" : "exclamationmark.circle.fill")
                                .foregroundColor(validValues ? .green : .red)
                            Text(validValues ? "All values are valid" : "Some of the values are missing or invalid")
                                .foregroundColor(validValues ? .green : .red)
                        }
                        
                    }
                    Section("Server details") {
                        TextField("Server name", text: $instanceFormModel.name)
                    }
                    Section("Connection details") {
                        Picker("Connection method", selection: $instanceFormModel.connectionMethod) {
                            Text("HTTP").tag("http")
                            Text("HTTPS").tag("https")
                        }
                        TextField("IP address or domain", text: $instanceFormModel.ipDomain).keyboardType(.URL)
                            .onChange(of: instanceFormModel.ipDomain) { _, newValue in
                                instanceFormModel.validateIpDomain(value: newValue)
                            }
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        TextField("Port", text: $instanceFormModel.port).keyboardType(.numberPad)
                            .onChange(of: instanceFormModel.port) { _, newValue in
                                instanceFormModel.validatePort(value: newValue)
                            }
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        TextField("Path (Example: /path)", text: $instanceFormModel.path).keyboardType(.URL)
                            .onChange(of: instanceFormModel.path) { _, newValue in
                                instanceFormModel.validatePath(value: newValue)
                            }
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    Section("Basic authentication") {
                        Toggle(
                            "Use basic authentication",
                            isOn: $instanceFormModel.useBasicAuth
                        ).onChange(of: instanceFormModel.useBasicAuth) {
                            instanceFormModel.toggleBasicAuth()
                        }
                        if instanceFormModel.useBasicAuth == true {
                            TextField("Username", text: $instanceFormModel.basicAuthUser)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            SecureField("Password", text: $instanceFormModel.basicAuthPassword)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                    }
                }
            }
            .navigationTitle(instanceFormModel.editId != "" ? "Edit instance" : "Create instance")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        instanceFormModel.modalOpen.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        instanceFormModel.saveInstance(instancesModel: instancesModel)
                    } label: {
                        Text("Save")
                    }
                    .disabled(!validValues)
                }
            })
        }
        .interactiveDismissDisabled()
    }
}

struct InstanceFormView_Previews: PreviewProvider {
    static var previews: some View {
        InstanceFormView(instanceFormModel: InstanceFormViewModel())
    }
}