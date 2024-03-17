func generateInstanceUrl(instance: ServerInstances) -> String {
    return "\(String(describing: instance.connectionMethod!))://\(String(describing: instance.ipDomain!))\(instance.port != nil ? ":\(String(describing: instance.port!))" : "")\(instance.path != nil ? String(describing: instance.path!) : "")"
}
