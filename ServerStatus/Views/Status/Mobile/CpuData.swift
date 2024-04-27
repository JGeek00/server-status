import SwiftUI

struct CpuData: View {
    let gaugeSize: Double
    @EnvironmentObject var statusModel: StatusViewModel
    
    @State var showSheet = false

    var body: some View {
        let data = statusModel.status?.last

        let cpuMaxTemp = data?.cpu?.cpuCores?.map({ return $0.temperatures?.first ?? 0 }).max()
        let cpuMaxTempLimit = data?.cpu?.cpuCores?.map({ return $0.temperatures?.last ?? 0 }).max()
        
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
                    Text(data?.cpu?.model ?? "N/A")
                        .font(.system(size: 16))
                }
                Spacer()
                DetailedViewButton(onTap: {
                    showSheet.toggle()
                })
                .padding(.trailing, 8)
            }
            Spacer().frame(height: 24)
            HStack {
                HStack {
                    Spacer()
                    if data?.cpu?.utilisation != nil {
                        Gauge(
                            value: "\(String(describing: Int(data!.cpu!.utilisation!*100)))%",
                            percentage: data!.cpu!.utilisation!*100,
                            icon: Image(systemName: "cpu"),
                            colors: gaugeColors,
                            size: gaugeSize
                        )
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    if cpuMaxTemp != nil && cpuMaxTempLimit != nil {
                        Gauge(
                            value: "\(String(describing: cpuMaxTemp!))ºC",
                            percentage: Double((cpuMaxTemp! * cpuMaxTempLimit!)/100),
                            icon: Image(systemName: "thermometer.medium"),
                            colors: gaugeColors,
                            size: gaugeSize
                        )
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showSheet, content: {
            DetailsSheet(hardwareItem: Enums.HardwareItem.cpu, onCloseSheet: { showSheet.toggle() })
        })
    }
}
