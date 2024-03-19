import SwiftUI

struct RamData: View {
    let gaugeSize: Double
    let containerWidth: Double
    @EnvironmentObject var statusView: StatusViewModel
    
    var body: some View {
        let data = statusView.status?.last
        
        VStack {
            HStack() {
                Image(systemName: "memorychip")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                Spacer().frame(width: 16)
                VStack(alignment: .leading) {
                    Text("Memory (RAM)")
                        .font(.system(size: 24))
                    Spacer().frame(height: 4)
                    Text("\(String(describing: formatMemoryValue(value: data?.memory?.total))) GB")
                        .font(.system(size: 16))
                }
                Spacer()
            }
            Spacer().frame(height: 24)
            HStack {
                Group {
                    if data?.memory?.total != nil && data?.memory?.available != nil {
                        let used = data!.memory!.total! - data!.memory!.available!
                        let perc = (Double(used)/Double(data!.memory!.total!))*100.0
                        Gauge(
                            value: "\(Int(perc))%",
                            percentage: perc,
                            icon: Image(systemName: "memorychip"),
                            colors: gaugeColors
                        ).frame(width: gaugeSize, height: gaugeSize)
                    }
                }.frame(width: containerWidth/2)
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            Text("\(String(describing: formatMemoryValue(value: data?.memory?.available))) GB")
                                .fontWeight(.bold)
                            Text("available")
                        }.font(.system(size: 18))
                        Spacer()
                        if (data?.memory?.swapAvailable != nil && data?.memory?.swapTotal != nil) {
                            HStack {
                                Text("\(String(describing: formatMemoryValue(value: data!.memory!.swapTotal! - data!.memory!.swapAvailable!))) GB")
                                    .fontWeight(.bold)
                                Text("on swap")
                            }.font(.system(size: 14))
                            Spacer()
                        }
                        HStack {
                            Text("\(String(describing: formatMemoryValue(value: data?.memory?.cached))) GB")
                                .fontWeight(.bold)
                            Text("cached")
                        }.font(.system(size: 14))
                        Spacer()
                    }
                    Spacer()
                }.frame(width: containerWidth/2)
            }
        }
    }
}
