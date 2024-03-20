import SwiftUI
import Charts

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

struct StorageDetail: View {
    @EnvironmentObject var statusModel: StatusViewModel
    @EnvironmentObject var appConfig: AppConfigViewModel
    
    var body: some View {
        let data = statusModel.status?.last
        List {
            Section("General status") {
                HStack {
                    Text("Total")
                    Spacer()
                    Text(storageValue(value: data?.storage?.home?.total))
                }
                HStack {
                    Text("Used")
                    Spacer()
                    Text(
                        data?.storage?.home?.total != nil && data?.storage?.home?.available != nil
                        ? storageValue(value: data!.storage!.home!.total! - Double(data!.storage!.home!.available!))
                            : "N/A"
                    )
                }
                HStack {
                    Text("Available")
                    Spacer()
                    Text(data?.storage?.home?.available != nil ? storageValue(value: Double(data!.storage!.home!.available!)) : "N/A")
                }
            }
            StorageChart()
        }
        .navigationTitle("Storage")
        .listStyle(InsetListStyle())
        .background(appConfig.getTheme() == ColorScheme.dark ? Color.black : Color.white)
    }
}

struct StorageChart: View {
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
        
        let unit = last?.storage?.home?.total != nil
            ? last!.storage!.home!.total!/1000000000 > 1000
                ? "TB"
                : "GB"
            : ""
        
        return reversedData.map() {
            return StorageChartData(
                id: UUID().uuidString,
                used: $0?.storage?.home?.total != nil && $0?.storage?.home?.available != nil
                ? (Double($0!.storage!.home!.total!) - Double($0!.storage!.home!.available!))/(unit == "TB" ? 1000000000000 : 1000000000)
                    : nil,
                total: $0?.storage?.home?.total != nil ? Double($0!.storage!.home!.total!)/(unit == "TB" ? 1000000000000 : 1000000000) : 0.0,
                unit: unit
            )
        }
    }
    
    var body: some View {
        let chartData = generateChartData()
        let maxValue = chartData?.map() { return $0.total ?? 0 }.max() ?? 0
        if chartData != nil {
            Section("Chart") {
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
                .listRowSeparator(.hidden)
            }
        }
    }
}

#Preview {
    StorageDetail()
}
