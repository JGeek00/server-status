func generateInstanceUrl(instance: ServerInstances) -> String {
    if instance.connectionMethod == nil || instance.ipDomain == nil {
        return ""
    }
    return "\(String(describing: instance.connectionMethod!))://\(String(describing: instance.ipDomain!))\(instance.port != nil ? ":\(String(describing: instance.port!))" : "")\(instance.path != nil ? String(describing: instance.path!) : "")"
}
