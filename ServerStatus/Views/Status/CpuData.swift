import SwiftUI

struct CpuData: View {
    let gaugeSize: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Image(systemName: "cpu")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                Spacer().frame(width: 16)
                VStack(alignment: .leading) {
                    Text("CPU")
                        .font(.system(size: 24))
                    Spacer().frame(height: 4)
                    Text("Intel N100")
                        .font(.system(size: 16))
                }
                Spacer()
            }
            Spacer().frame(height: 24)
            HStack {
                HStack {
                    Spacer()
                    Gauge(
                        value: "20%",
                        percentage: 20,
                        icon: Image(systemName: "cpu"),
                        colors: gaugeColors
                    ).frame(width: gaugeSize, height: gaugeSize)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Gauge(
                        value: "54ºC",
                        percentage: 54,
                        icon: Image(systemName: "thermometer.medium"),
                        colors: gaugeColors
                    ).frame(width: gaugeSize, height: gaugeSize)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    CpuData(gaugeSize: (UIScreen.main.bounds.width*0.5)/2.0)
}
