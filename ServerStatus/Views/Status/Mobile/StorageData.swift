import SwiftUI

struct StorageData: View {
    let gaugeSize: Double
    let containerWidth: Double
    
    @EnvironmentObject var statusModel: StatusViewModel
    
    @State var showSheet = false
    
    var body: some View {
        let data = statusModel.status?.last
        let total = data?.storage?.map() { $0.total ?? 0 }.max()
        let available = data?.storage?.map() { $0.available ?? 0 }.max()
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
                    Text(storageValue(value: total))
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
                Group {
                    if available != nil && total != nil {
                        let percent = 100.0-((Double(available!)/Double(total!))*100.0)
                        Gauge(
                            value: "\(Int(percent))%",
                            percentage: percent,
                            icon: Image(systemName: "internaldrive"),
                            colors: gaugeColors,
                            size: gaugeSize
                        )
                    }
                }.frame(width: containerWidth/2)
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            Text("\(data?.storage?.count ?? 0)")
                                .fontWeight(.bold)
                            Text(data?.storage?.count == 1 ? "volume" : "volumes")
                        }.font(.system(size: 16))
                        Spacer().frame(height: 16)
                        HStack {
                            let merged = data?.storage != nil ? data!.storage!.map() { $0.available ?? 0}.max() ?? 0 : 0
                            Text(storageValue(value: Double(merged)))
                                .fontWeight(.bold)
                            Text("available")
                        }.font(.system(size: 16))
                        Spacer()
                    }
                    Spacer()
                }.frame(width: containerWidth/2)
            }
        }
        .sheet(isPresented: $showSheet, content: {
            DetailsSheet(hardwareItem: Enums.HardwareItem.storage, onCloseSheet: { showSheet.toggle() })
        })
    }
}
