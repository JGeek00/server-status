import SwiftUI

struct NetworkData: View {
    @EnvironmentObject var statusModel: StatusViewModel
    
    @State var showSheet = false
    
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
                DetailedViewButton(onTap: {
                    showSheet.toggle()
                })
                .padding(.trailing, 8)
            }
            Spacer().frame(height: 24)
            GeometryReader(content: { geometry in
                HStack {
                    if data?.network?.rx != nil {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.system(size: 40))
                            Spacer().frame(height: 16)
                            Text(previous?.network?.rx != nil ? formatBits(value: abs(data!.network!.rx! - previous!.network!.rx!)) : "0 Bit/s")
                            Spacer().frame(height: 8)
                            Text(previous?.network?.rx != nil ? formatBytes(value: abs(data!.network!.rx! - previous!.network!.rx!)) : "0 B/s")
                        }
                        .frame(width: geometry.size.width/2)
                    }
                    if data?.network?.tx != nil {
                        VStack {
                            Image(systemName: "arrow.up.circle")
                                .font(.system(size: 40))
                            Spacer().frame(height: 16)
                            Text(previous?.network?.rx != nil ? formatBits(value: abs(data!.network!.tx! - previous!.network!.tx!)) : "0 Bit/s")
                            Spacer().frame(height: 8)
                            Text(previous?.network?.rx != nil ? formatBytes(value: abs(data!.network!.tx! - previous!.network!.tx!)) : "0 B/s")
                        }
                        .frame(width: geometry.size.width/2)
                    }
                }
            })
            Spacer().frame(height: 90)
        }
        .sheet(isPresented: $showSheet, content: {
            DetailsSheet(hardwareItem: Enums.HardwareItem.network, onCloseSheet: { showSheet.toggle() })
        })
    }
}
