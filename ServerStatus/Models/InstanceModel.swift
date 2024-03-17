class InstanceModel {
    let id: String
    let instanceName: String
    let connectionMethod: String
    let ipDomain: String
    let port: Int?
    let path: String?
    let useBasicAuth: Bool
    let basicAuthUser: String?
    let basicAuthPassword: String?
    
    init(id: String, instanceName: String, connectionMethod: String, ipDomain: String, port: Int?, path: String?, useBasicAuth: Bool, basicAuthUser: String?, basicAuthPassword: String?) {
        self.id = id
        self.instanceName = instanceName
        self.connectionMethod = connectionMethod
        self.ipDomain = ipDomain
        self.port = port
        self.path = path
        self.useBasicAuth = useBasicAuth
        self.basicAuthUser = basicAuthUser
        self.basicAuthPassword = basicAuthPassword
    }
}
