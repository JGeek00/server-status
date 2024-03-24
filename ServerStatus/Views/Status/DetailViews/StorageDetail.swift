import SwiftUI
import Charts

struct StorageDetail: View {
    let onCloseSheet: (() -> Void)?
    
    var body: some View {
        if onCloseSheet != nil {
            StorageList(onCloseSheet: onCloseSheet)
                .listStyle(DefaultListStyle())
        }
        else {
            StorageList(onCloseSheet: onCloseSheet)
                .listStyle(InsetListStyle())
        }
    }
}


private struct StorageList: View {
    let onCloseSheet: (() -> Void)?
    
    @EnvironmentObject var statusModel: StatusViewModel
    @EnvironmentObject var appConfig: AppConfigViewModel
    @EnvironmentObject var instancesModel: InstancesViewModel
    
    var body: some View {
        let data = statusModel.status?.last
        List {
            if data?.storage != nil {
                ForEach(data!.storage!.indices, id: \.self) { index in
                    let entry = data!.storage![index]
                    Section(entry.name ?? "") {
                        HStack {
                            Text("Total")
                            Spacer()
                            Text(storageValue(value: entry.total))
                        }
                        HStack {
                            Text("Used")
                            Spacer()
                            Text(
                                entry.total != nil && entry.available != nil
                                    ? storageValue(value: entry.total! - Double(entry.available!))
                                    : "N/A"
                            )
                        }
                        HStack {
                            Text("Available")
                            Spacer()
                            Text(entry.available != nil ? storageValue(value: Double(entry.available!)) : "N/A")
                        }
                        StorageChart(storageIndex: index)
                    }
                }
            }
        }
        .navigationTitle("Storage")
        .background(appConfig.getTheme() == ColorScheme.dark ? Color.black : Color.white)
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
                    guard let instance = instancesModel.selectedInstance else { return }
                    Task { await statusModel.fetchStatus(serverInstance: instance, showError: false) }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

private class StorageChartData {
    let id: String
    let used: Double?
    let total: Double?
    let unit: String?
    
    init(id: String, used: Double?, total: Double?, unit: String?) {
        self.id = id
        self.used = used
        self.total = total
        self.unit = unit
    }
}

private struct StorageChart: View {
    let storageIndex: Int
    
    @EnvironmentObject var statusModel: StatusViewModel
    
    private func generateChartData() -> [StorageChartData]? {
        guard let data = statusModel.status else { return nil }
        var reversedData: [StatusModel?] = data.reversed()
        if reversedData.count < ChartsConfig.points {
            reversedData.append(contentsOf: Array(repeating: nil, count: ChartsConfig.points-reversedData.count))
        }
        else {
            reversedData = Array(reversedData.prefix(ChartsConfig.points))
        }
        
        guard let last = reversedData.last else { return nil }
        
        let unit = last?.storage?[storageIndex].total != nil
            ? last!.storage![storageIndex].total!/1000000000 > 1000
                ? "TB"
                : "GB"
            : ""
        
        return reversedData.map() {
            return StorageChartData(
                id: UUID().uuidString,
                used: $0?.storage?[storageIndex].total != nil && $0?.storage?[storageIndex].available != nil
                ? (Double($0!.storage![storageIndex].total!) - Double($0!.storage![storageIndex].available!))/(unit == "TB" ? 1000000000000 : 1000000000)
                    : nil,
                total: $0?.storage![storageIndex].total != nil ? Double($0!.storage![storageIndex].total!)/(unit == "TB" ? 1000000000000 : 1000000000) : 0.0,
                unit: unit
            )
        }
    }
    
    var body: some View {
        let chartData = generateChartData()
        let maxValue = chartData?.map() { return $0.total ?? 0 }.max() ?? 0
        if chartData != nil {
            Chart {
                ForEach(Array(chartData!.enumerated()), id: \.element.id) { index, item in
                    LineMark(
                        x: .value("", index),
                        y: .value("Storage", (item.used ?? 0))
                    )
                }
            }
            .chartYScale(domain: 0...maxValue)
            .chartYAxisLabel(LocalizedStringKey("Storage"))
            .chartXAxis(Visibility.hidden)
            .frame(height: 300)
            .padding(.bottom, 16)
            .listRowSeparator(.hidden)
        }
    }
}

#Preview {
    StorageDetail(onCloseSheet: nil)
}
