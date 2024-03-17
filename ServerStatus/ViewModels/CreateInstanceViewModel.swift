import Foundation
import Combine

class CreateInstanceViewModel: ObservableObject {
    @Published var modalOpen = false
    
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
    
    func reset() {
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
}
