import Foundation

func formatMemoryValue(value: Int?) -> String {
    guard let v = value else { return "N/A" }
    return String(format: "%.1f", Double(v)/1048576.0)
}

func cacheValue(value: Int?) -> String {
    guard let v = value else { return "N/A" }
    let mb = Double(v)/1000.0
    return "\(String(format: "%.2f", mb)) MB"
}


func storageValue(value: Double?) -> String {
    guard let v = value else { return "N/A" }
    if v/1000000000 > 1000 {
        return "\(String(format: "%.1f", v/1000000000000)) TB"
    }
    else {
        return "\(String(format: "%.1f", v/1000000000)) GB"
    }
}

func formatBits(value: Int?) -> String {
    guard let v = value else { return "N/A" }
    let kbps = Double(v)/1000.0
    if kbps <= 1000 {
        return "\(String(format: "%.2f", kbps)) Kbit/s"
    }
    let mbps = kbps/1000.0
    if mbps <= 1000 {
        return "\(String(format: "%.2f", mbps)) Mbit/s"
    }
    let gbps = mbps/1000.0
    if mbps <= 1000 {
        return "\(String(format: "%.2f", gbps)) Gbit/s"
    }
    return "N/A"
}

func formatBytes(value: Int?) -> String {
    guard let v = value else { return "N/A" }
    let kbps = (Double(v)/8.0)/1000.0
    if kbps <= 1000 {
        return "\(String(format: "%.2f", kbps)) KB/s"
    }
    let mbps = kbps/1000.0
    if mbps <= 1000 {
        return "\(String(format: "%.2f", mbps)) MB/s"
    }
    let gbps = mbps/1000.0
    if mbps <= 1000 {
        return "\(String(format: "%.2f", gbps)) GB/s"
    }
    return "N/A"
}

func formatPrice(value: NSDecimalNumber, locale: Locale) -> String? {
    let nf = NumberFormatter()
    nf.numberStyle = .currency
    nf.locale = locale
    return nf.string(from: value)
}
