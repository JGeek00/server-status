import SwiftUI

struct RamData: View {
    let gaugeSize: Double
    let containerWidth: Double
    
    var body: some View {
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
                    Text("16 GB")
                        .font(.system(size: 16))
                }
                Spacer()
            }
            Spacer().frame(height: 24)
            HStack {
                Group {
                    Gauge(
                        value: "76%",
                        percentage: 76,
                        icon: Image(systemName: "memorychip"),
                        colors: gaugeColors
                    ).frame(width: gaugeSize, height: gaugeSize)
                }.frame(width: containerWidth/2)
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            Text("13 GB")
                                .fontWeight(.bold)
                            Text("available")
                        }.font(.system(size: 18))
                        Spacer()
                        HStack {
                            Text("5 GB")
                                .fontWeight(.bold)
                            Text("on swap")
                        }.font(.system(size: 14))
                        Spacer()
                        HStack {
                            Text("1 GB")
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
