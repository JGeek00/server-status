import SwiftUI

struct NetworkData: View {
    @StateObject var statusModel: StatusViewModel
    
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
    
    var body: some View {
        let data = statusModel.status?.last
        let previous = statusModel.status != nil ? statusModel.status!.count > 1 ? statusModel.status![statusModel.status!.count-2] : nil : nil
        VStack(alignment: .leading) {
            HStack() {
                Image(systemName: "network")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                Spacer().frame(width: 16)
                VStack(alignment: .leading) {
                    Text("Network")
                        .font(.system(size: 24))
                    Spacer().frame(height: 4)
                    Text(data?.network?.speed != nil ? "\(String(format: "%.1f", Double(data!.network!.speed!/1000))) Gbit/s" : "N/A")
                        .font(.system(size: 16))
                }
                Spacer()
            }
            Spacer().frame(height: 24)
            HStack {
                Spacer()
                if data?.network?.rx != nil {
                    VStack {
                        Image(systemName: "arrow.down.circle")
                            .font(.system(size: 40))
                        Spacer().frame(height: 16)
                        Text(previous?.network?.rx != nil ? formatBits(value: abs(data!.network!.rx! - previous!.network!.rx!)) : "0 Bit/s")
                        Spacer().frame(height: 8)
                        Text(previous?.network?.rx != nil ? formatBytes(value: abs(data!.network!.rx! - previous!.network!.rx!)) : "0 B/s")
                    }
                }
                Spacer()
                if data?.network?.tx != nil {
                    VStack {
                        Image(systemName: "arrow.up.circle")
                            .font(.system(size: 40))
                        Spacer().frame(height: 16)
                        Text(previous?.network?.rx != nil ? formatBits(value: abs(data!.network!.tx! - previous!.network!.tx!)) : "0 Bit/s")
                        Spacer().frame(height: 8)
                        Text(previous?.network?.rx != nil ? formatBytes(value: abs(data!.network!.tx! - previous!.network!.tx!)) : "0 B/s")
                    }
                }
                Spacer()
            }
        }
    }
}
