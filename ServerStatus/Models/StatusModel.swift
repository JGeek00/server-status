import Foundation

// MARK: - Status
struct StatusModel: Codable {
    let storage: [Storage]?
    let network: Network?
    let memory: Memory?
    let cpu: CPU?
    let host: Host?
}

// MARK: - CPU
struct CPU: Codable {
    let count: Int?
    let utilisation: Double?
    let model: String?
    let cores, cache: Int?
    let cpuCores: [CPUCore]?
}

// MARK: - CPU Core
struct CPUCore: Codable {
    let temperatures: [Int]?
    let frequencies: Frequency?
}

// MARK: - Frequency
struct Frequency: Codable {
    let base, max, now, min: Int?
}

// MARK: - Host
struct Host: Codable {
    let uptime: Double?
    let os, hostname: String?
    let loadavg: [Double]?
    let appMemory: String?
    
    enum CodingKeys: String, CodingKey {
        case uptime, os, hostname, loadavg
        case appMemory = "app_memory"
    }
}

// MARK: - Memory
struct Memory: Codable {
    let cached, processes, swapAvailable, swapTotal: Int?
    let total, available: Int?
    
    enum CodingKeys: String, CodingKey {
        case cached, processes
        case swapAvailable = "swap_available"
        case swapTotal = "swap_total"
        case total, available
    }
}

// MARK: - Network
struct Network: Codable {
    let speed: Int?
    let interface: String?
    let rx, tx: Int?
}

// MARK: - Storage
struct Storage: Codable {
    let name: String?
    let total: Double?
    let icon: String?
    let available: Int?
}


func transformStatusJSON(_ input: [String: Any]) -> [String: Any] {
    var output = input
    
    if let cpu = input["cpu"] as? [String: Any] {
        var coresData: [[String: Any]] = []
        
        let temperatures = cpu["temperatures"] as? [String: [Double]]
        let frequencies = cpu["frequencies"] as? [String: [String: Int]]
        
        var convertedFrequencies = [[String: Int]]()
        if frequencies != nil {
            for (index, values) in frequencies! {
                var coreData: [String: Any] = [:]
                if temperatures?["Core \(index.replacingOccurrences(of: "cpu", with: ""))"] != nil {
                    coreData = coreData.merging([
                        "temperatures": (temperatures!["Core \(index.replacingOccurrences(of: "cpu", with: ""))"]) as Any,
                        "frequencies": values
                    ]) { (_, new) in new }
                }
                else {
                    coreData = coreData.merging([
                        "frequencies": values
                    ]) { (_, new) in new }
                }
                coresData.append(coreData)
                convertedFrequencies.append(values)
            }
        }

        output["cpu"] = cpu.merging(["cpuCores": coresData]) { (_, new) in new }
    }
    
    if let storage = input["storage"] as? [String: [String: Any]] {
        var convertedStorage: [Any] = []
        
        for (key, values) in storage {
            var newValues: [String: Any] = values
            newValues.merge(["name": key]) { (_, new) in new }
            convertedStorage.append(newValues)
        }
        
        output["storage"] = convertedStorage
    }

    return output
}


class StatusResponse {
    let successful: Bool
    let statusCode: Int?
    let data: Data?
    
    init(successful: Bool, statusCode: Int?, data: Data?) {
        self.successful = successful
        self.statusCode = statusCode
        self.data = data
    }
}
