import SwiftUI

struct StorageData: View {
    let gaugeSize: Double
    let containerWidth: Double
    
    @EnvironmentObject var statusModel: StatusViewModel
    
    @State var showSheet = false
    
    var body: some View {
        let data = statusModel.status?.last
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
                    Text(storageValue(value: data?.storage?.home?.total))
                        .font(.system(size: 16))
                }
                Spacer()
                DetailedViewButton(onTap: {
                    showSheet.toggle()
                })
            }
            Spacer().frame(height: 24)
            HStack {
                Group {
                    if data?.storage?.home?.available != nil && data?.storage?.home?.total != nil {
                        let percent = 100.0-((Double(data!.storage!.home!.available!)/Double(data!.storage!.home!.total!))*100.0)
                        Gauge(
                            value: "\(Int(percent))%",
                            percentage: percent,
                            icon: Image(systemName: "internaldrive"),
                            colors: gaugeColors
                        ).frame(width: gaugeSize, height: gaugeSize)
                    }
                }.frame(width: containerWidth/2)
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            Text(storageValue(value: Double(data?.storage?.home?.available ?? 0)))
                                .fontWeight(.bold)
                            Text("available")
                        }.font(.system(size: 18))
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
