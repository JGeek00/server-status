import SwiftUI

struct CreateInstanceView: View {
    @ObservedObject var createInstanceModel: CreateInstanceViewModel
    
    func generateInstanceUrl() -> String {
        return "\(String(createInstanceModel.connectionMethod).lowercased())://\(createInstanceModel.ipDomain)\(createInstanceModel.port != "" ? ":\(createInstanceModel.port)" : "")\(createInstanceModel.path)"
    }
    
    var body: some View {
        let validValues = createInstanceModel.ipDomainValid && createInstanceModel.portValid && createInstanceModel.pathValid && ((createInstanceModel.useBasicAuth && createInstanceModel.basicAuthUser != "" && createInstanceModel.basicAuthPassword != "") || !createInstanceModel.useBasicAuth)
        let url = generateInstanceUrl()
        NavigationView {
            Form {
                List {
                    Section() {
                        Text(url != "" ? url : "Instance URL")
                            .foregroundColor(url != "" ? .blue : .gray)
                        if !validValues {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("Some of the values are missing or invalid")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    Section("Connection details") {
                        Picker("Connection method", selection: $createInstanceModel.connectionMethod) {
                            Text("HTTP").tag("http")
                            Text("HTTPS").tag("https")
                        }
                        TextField("IP address or domain", text: $createInstanceModel.ipDomain).keyboardType(.URL)
                            .onChange(of: createInstanceModel.ipDomain) { _, newValue in
                                createInstanceModel.validateIpDomain(value: newValue)
                            }
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        TextField("Port", text: $createInstanceModel.port).keyboardType(.numberPad)
                            .onChange(of: createInstanceModel.port) { _, newValue in
                                createInstanceModel.validatePort(value: newValue)
                            }
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        TextField("Path (Example: /path)", text: $createInstanceModel.path).keyboardType(.URL)
                            .onChange(of: createInstanceModel.path) { _, newValue in
                                createInstanceModel.validatePath(value: newValue)
                            }
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    Section("Basic authentication") {
                        Toggle(
                            "Use basic authentication",
                            isOn: $createInstanceModel.useBasicAuth
                        ).onChange(of: createInstanceModel.useBasicAuth) {
                            createInstanceModel.toggleBasicAuth()
                        }
                        if createInstanceModel.useBasicAuth == true {
                            TextField("Username", text: $createInstanceModel.basicAuthUser)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            SecureField("Password", text: $createInstanceModel.basicAuthPassword)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                    }
                }
            }
            .navigationTitle("Create instance")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        createInstanceModel.modalOpen.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
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

struct CreateInstanceView_Previews: PreviewProvider {
    static var previews: some View {
        CreateInstanceView(createInstanceModel: CreateInstanceViewModel())
    }
}
