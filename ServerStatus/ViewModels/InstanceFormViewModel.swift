import Foundation
import Combine
import CoreData

class InstanceFormViewModel: ObservableObject {
    @Published var modalOpen = false
    
    @Published var editId = ""
    @Published var name = ""
    @Published var connectionMethod = "HTTP"
    @Published var ipDomain = ""
    @Published var ipDomainValid = true
    @Published var port = ""
    @Published var portValid = true
    @Published var path = ""
    @Published var pathValid = true
    @Published var useBasicAuth = false
    @Published var basicAuthUser = ""
    @Published var basicAuthPassword = ""
    
    @Published var isLoading = false
    
    private let persistenceController = PersistenceController.shared
    
    func reset() {
        editId = ""
        name = ""
        connectionMethod = "HTTP"
        ipDomain = ""
        ipDomainValid = true
        port = ""
        portValid = true
        path = ""
        pathValid = true
        useBasicAuth = false
        basicAuthUser = ""
        basicAuthPassword = ""
    }
    
    func toggleBasicAuth() {
        basicAuthUser = ""
        basicAuthPassword = ""
    }
    
    func validateIpDomain(value: String) {
        let domainValid = NSPredicate(format: "SELF MATCHES %@", Regexps.domain).evaluate(with: value)
        let ipValid = NSPredicate(format: "SELF MATCHES %@", Regexps.ipAddress).evaluate(with: value)
        if domainValid || ipValid {
            ipDomainValid = true
        }
        else {
            ipDomainValid = false
        }
    }
    
    func validatePort(value: String) {
        if value == "" {
            portValid = true
            return
        }
        let parsed = Int(value)
        if parsed == nil {
            portValid = false
            return
        }
        if parsed! <= 65535 {
            portValid = true
        }
        else {
            portValid = false
        }
    }
    
    func validatePath(value: String) {
        if value == "" {
            pathValid = true
            return
        }
        let valid = NSPredicate(format: "SELF MATCHES %@", Regexps.path).evaluate(with: value)
        if valid {
            pathValid = true
        }
        else {
            pathValid = false
        }
    }
    
    func saveInstance(instancesModel: InstancesViewModel) {
        Task {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            let baseUrl = "\(String(describing: connectionMethod))://\(String(describing: ipDomain))\(port != "" ? ":\(String(describing: port))" : "")\(path != "" ? String(describing: path) : "")"
            let response = await ApiClient.status(
                baseUrl: baseUrl,
                token: useBasicAuth ? encodeCredentialsBasicAuth(username: basicAuthUser, password: basicAuthPassword) : nil
            )
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if response.data == nil {
                return
            }
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]
                let jsonData = try JSONSerialization.data(withJSONObject: transformStatusJSON(jsonDictionary!), options: [])
                let data = try JSONDecoder().decode(StatusModel.self, from: Data(jsonData))
                print(data)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
//            if editId != "" {
//                instancesModel.editInstance(
//                    id: editId,
//                    name: name,
//                    connectionMethod: String(connectionMethod).lowercased(),
//                    ipDomain: ipDomain,
//                    port: port != "" ? port : nil,
//                    path: path != "" ? path : nil,
//                    useBasicAuth: useBasicAuth,
//                    basicAuthUser: basicAuthUser != "" ? basicAuthUser : nil,
//                    basicAuthPassword: basicAuthPassword != "" ? basicAuthPassword : nil
//                )
//            }
//            else {
//                instancesModel.createInstance(
//                    id: UUID().uuidString,
//                    name: name,
//                    connectionMethod: String(connectionMethod).lowercased(),
//                    ipDomain: ipDomain,
//                    port: port != "" ? port : nil,
//                    path: path != "" ? path : nil,
//                    useBasicAuth: useBasicAuth,
//                    basicAuthUser: basicAuthUser != "" ? basicAuthUser : nil,
//                    basicAuthPassword: basicAuthPassword != "" ? basicAuthPassword : nil
//                )
//            }
//            modalOpen.toggle()
        }
    }
}
