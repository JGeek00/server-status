import SwiftUI

struct StorageData: View {
    let gaugeSize: Double
    let containerWidth: Double
    
    var body: some View {
        VStack {
            HStack() {
                Image(systemName: "internaldrive")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                Spacer().frame(width: 16)
                VStack(alignment: .leading) {
                    Text("Storage")
                        .font(.system(size: 24))
                    Spacer().frame(height: 4)
                    Text("500 GB")
                        .font(.system(size: 16))
                }
                Spacer()
            }
            Spacer().frame(height: 24)
            HStack {
                Group {
                    Gauge(
                        value: "47%",
                        percentage: 47,
                        icon: Image(systemName: "internaldrive"),
                        colors: gaugeColors
                    ).frame(width: gaugeSize, height: gaugeSize)
                }.frame(width: containerWidth/2)
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            Text("450 GB")
                                .fontWeight(.bold)
                            Text("available")
                        }.font(.system(size: 18))
                        Spacer()
                    }
                    Spacer()
                }.frame(width: containerWidth/2)
            }
        }
    }
}

#Preview {
    StorageData(
        gaugeSize: (UIScreen.main.bounds.width*0.5)/2.0,
        containerWidth: UIScreen.main.bounds.width - 32
    ).frame(height: 40)
}
