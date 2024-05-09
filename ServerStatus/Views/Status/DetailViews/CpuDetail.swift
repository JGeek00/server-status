import SwiftUI
import Charts

struct CpuDetail: View {
    let onCloseSheet: (() -> Void)?

    var body: some View {
        if onCloseSheet != nil {
            CpuList(onCloseSheet: onCloseSheet)
                .listStyle(DefaultListStyle())
        }
        else {
            CpuList(onCloseSheet: onCloseSheet)
                .listStyle(InsetListStyle())
        }
    }
}

private struct CpuList: View {
    let onCloseSheet: (() -> Void)?
    
    @EnvironmentObject var statusModel: StatusViewModel
    @EnvironmentObject var instancesModel: InstancesViewModel
    
    var body: some View {
        let data = statusModel.status?.last
        let cpuMaxTemp = data?.cpu?.cpuCores?.map({ return $0.temperatures?.first ?? 0 }).max()
        List {
            Section("Information") {
                HStack {
                    Text("Model")
                    Spacer()
                    Text(data?.cpu?.model ?? "N/A")
                }
                HStack {
                    Text("Core count")
                    Spacer()
                    Text("\(data?.cpu?.cores != nil ? String(data!.cpu!.cores!) : "N/A") physical cores, \(data?.cpu?.count != nil ? String(data!.cpu!.count!) : "N/A") execution threads")
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Cache")
                    Spacer()
                    Text("\(cacheValue(value: data?.cpu?.cache))")
                }
            }
            Section("General status") {
                HStack {
                    Text("Load")
                    Spacer()
                    Text(data?.cpu?.utilisation != nil ? "\(Int(data!.cpu!.utilisation!*100))%" : "N/A")
                }
                HStack {
                    Text("Temperature")
                    Spacer()
                    Text(cpuMaxTemp != nil ? "\(cpuMaxTemp!)ºC" : "N/A")
                }
            }
            if data?.cpu?.cpuCores != nil {
                ForEach(data!.cpu!.cpuCores!.indices, id: \.self) { index in
                    CpuCharts(index: index, inSheet: onCloseSheet != nil)
                }
            }
        }
        .navigationTitle("CPU")
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
                    guard let instance = instancesModel.selectedInstance else { return }
                    Task { await statusModel.fetchStatus(serverInstance: instance, showError: false) }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

private class CpuChartData {
    let id: String
    let frequency: Int?
    let minFrequency: Int?
    let maxFrequency: Int?
    let temperature: Int?
    let maxTemperature: Int?
    
    init(id: String, frequency: Int?, minFrequency: Int?, maxFrequency: Int?, temperature: Int?, maxTemperature: Int?) {
        self.id = id
        self.frequency = frequency
        self.minFrequency = minFrequency
        self.maxFrequency = maxFrequency
        self.temperature = temperature
        self.maxTemperature = maxTemperature
    }
}

private struct CpuCharts: View {
    let index: Int
    let inSheet: Bool
    
    @EnvironmentObject var statusModel: StatusViewModel
    
    private func generateChartData() -> [CpuChartData]? {
        guard let data = statusModel.status else { return nil }
        var reversedData: [StatusModel?] = data.reversed()
        if reversedData.count < ChartsConfig.points {
            reversedData.append(contentsOf: Array(repeating: nil, count: ChartsConfig.points-reversedData.count))
        }
        else {
            reversedData = Array(reversedData.prefix(ChartsConfig.points))
        }
        
        return reversedData.map() {
            return CpuChartData(
                id: UUID().uuidString,
                frequency: $0?.cpu?.cpuCores?[index].frequencies?.now ?? 0,
                minFrequency: $0?.cpu?.cpuCores?[index].frequencies?.min ?? 0,
                maxFrequency: $0?.cpu?.cpuCores?[index].frequencies?.max ?? 0,
                temperature: $0?.cpu?.cpuCores?[index].temperatures?[0] ?? 0,
                maxTemperature: $0?.cpu?.cpuCores?[index].temperatures?[1] ?? 0
            )
        }
    }
    
    var body: some View {
        let chartData = generateChartData()
        let maxFrequency = chartData?.map() { return $0.maxFrequency ?? 0 }.max() ?? 0
        let maxTemperature = chartData?.map() { return $0.maxTemperature ?? 0 }.max() ?? 0
        if chartData != nil {
            Section("Core \(index)") {
                if inSheet {
                    CpuChart(chartData: chartData!, maxValue: maxFrequency, type: "freq")
                        .padding(.top, 8)
                        .listRowSeparator(.hidden)
                    HStack {}
                    CpuChart(chartData: chartData!, maxValue: maxTemperature, type: "temp")
                        .padding(.bottom, 16)
                        .listRowSeparator(.hidden)
                    
                }
                else {
                    HStack {
                        CpuChart(chartData: chartData!, maxValue: maxFrequency, type: "freq")
                        Spacer().frame(width: 32)
                        CpuChart(chartData: chartData!, maxValue: maxTemperature, type: "temp")
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
    }
}

private struct CpuChart: View {
    let chartData: [CpuChartData]
    let maxValue: Int
    let type: String
    
    var body: some View {
        Chart {
            ForEach(Array(chartData.enumerated()), id: \.element.id) { index, item in
                LineMark(
                    x: .value("", index),
                    y: .value(type == "freq" ? LocalizedStringKey("Frequency") : LocalizedStringKey("Temperature"), (type == "freq" ? item.frequency : item.temperature) ?? 0)
                )
            }
        }
        .chartYScale(domain: 0...maxValue)
        .chartYAxisLabel(type == "freq" ? LocalizedStringKey("Frequency (MHz)") : LocalizedStringKey("Temperature (ºC)"))
        .chartXAxis(Visibility.hidden)
        .frame(height: 200)
    }
}


#Preview {
    CpuDetail(onCloseSheet: nil)
}
