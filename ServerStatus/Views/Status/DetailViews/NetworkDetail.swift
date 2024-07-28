import SwiftUI
import Charts

struct NetworkDetail: View {
    let onCloseSheet: (() -> Void)?
    
    var body: some View {
        if onCloseSheet != nil {
            NetworkList(onCloseSheet: onCloseSheet)
                .listStyle(DefaultListStyle())
        }
        else {
            NetworkList(onCloseSheet: onCloseSheet)
                .listStyle(InsetListStyle())
        }
    }
}


private struct NetworkList: View {
    let onCloseSheet: (() -> Void)?
    
    @EnvironmentObject var statusProvider: StatusProvider
    
    var body: some View {
        let data = statusProvider.status?.last
        List {
            Section("Information") {
                HStack {
                    Text("Interface")
                    Spacer()
                    Text(data?.network?.interface ?? "N/A")
                }
                HStack {
                    Text("Speed")
                    Spacer()
                    Text(data?.network?.speed != nil ? "\(String(format: "%.1f", Double(data!.network!.speed!/1000))) Gbit/s" : "N/A")
                }
            }
            NetworkChart()
        }
        .navigationTitle("Network")
        .background(Color.foreground)
        .toolbar {
            if onCloseSheet != nil {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton(onClose: {
                        onCloseSheet!()
                    })
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await statusProvider.fetchStatus() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

private struct NetworkChartData: Equatable {
    let id: String
    let tx: Double?
    let rx: Double?
    
    init(id: String, tx: Double?, rx: Double?) {
        self.id = id
        self.tx = tx
        self.rx = rx
    }
}

private struct NetworkChart: View {
    @EnvironmentObject var statusProvider: StatusProvider
    
    private func generateChartData() -> [NetworkChartData]? {
        guard let data = statusProvider.status else { return nil }
        let reversedData: [StatusModel?] = data.reversed()
        
        var networkData: [NetworkChartData] = []
        reversedData.enumerated().forEach() { index, item in
            if index > 0 {
                let previous = reversedData[index-1]
                networkData.append(
                    NetworkChartData(
                        id: UUID().uuidString,
                        tx: item?.network?.tx != nil && previous?.network?.tx != nil
                            ? Double(abs(item!.network!.tx! - previous!.network!.tx!))/1000.0
                            : 0,
                        rx: item?.network?.rx != nil && previous?.network?.rx != nil
                            ? Double(abs(item!.network!.rx! - previous!.network!.rx!))/1000.0
                            : 0
                    )
                )
            }
        }
        
        if networkData.count < ChartsConfig.points {
            for _ in 0..<(ChartsConfig.points-networkData.count) {
                networkData.append(NetworkChartData(id: UUID().uuidString, tx: 0, rx: 0))
            }
        }
        else {
            networkData = Array(networkData.prefix(ChartsConfig.points))
        }
        
        return networkData
    }
    
    var body: some View {
        let chartData = generateChartData()
        if chartData != nil {
            let maxValue = (chartData!.map() { return $0.tx ?? 0 } + chartData!.map() { return $0.rx ?? 0 }).max()
            Section("Chart") {
                VStack {
                    Chart {
                        ForEach(Array(chartData!.enumerated()), id: \.element.id) { index, item in
                            LineMark(
                                x: .value("", index),
                                y: .value("TX", item.tx ?? 0),
                                series: .value("TX", "A")
                            )
                            .foregroundStyle(Color.blue)
                            .interpolationMethod(.catmullRom)
                            AreaMark(
                                x: .value("", index),
                                yStart: .value("TX", 0),
                                yEnd: .value("TX", item.tx ?? 0),
                                series: .value("TX", "A")
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .blue.opacity(0.5),
                                        .blue.opacity(0.2),
                                        .blue.opacity(0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)
                            LineMark(
                                x: .value("", index),
                                y: .value("RX", item.rx ?? 0),
                                series: .value("RX", "B")
                            )
                            .foregroundStyle(Color.green)
                            .interpolationMethod(.catmullRom)
                            AreaMark(
                                x: .value("", index),
                                yStart: .value("RX", 0),
                                yEnd: .value("RX", item.rx ?? 0),
                                series: .value("RX", "B")
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .green.opacity(0.5),
                                        .green.opacity(0.2),
                                        .green.opacity(0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)
                        }
                    }
                    .chartYScale(domain: 0...(maxValue! > 0 ? maxValue! : 10))
                    .chartYAxisLabel("Data transfer (Kbit/s)")
                    .chartXAxis(Visibility.hidden)
                    .frame(height: 300)
                    Spacer().frame(height: 16)
                    HStack {
                        HStack {
                            BasicChartSymbolShape.circle
                                .foregroundColor(Color.blue)
                                .frame(width: 8, height: 8)
                            Text("TX")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        HStack {
                            Spacer().frame(width: 16)
                            BasicChartSymbolShape.circle
                                .foregroundColor(Color.green)
                                .frame(width: 8, height: 8)
                            Text("RX")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        Spacer()
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: chartData)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .listRowSeparator(.hidden)
            }
        }
    }
}
