import SwiftUI
import Charts

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

struct CpuCharts: View {
    let index: Int
    
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
                frequency: $0?.cpu?.frequencies?[index].now ?? 0,
                minFrequency: $0?.cpu?.frequencies?[index].min ?? 0,
                maxFrequency: $0?.cpu?.frequencies?[index].max ?? 0,
                temperature: $0?.cpu?.temperatures?[index][0] ?? 0,
                maxTemperature: $0?.cpu?.temperatures?[index][1] ?? 0
            )
        }
    }
    
    var body: some View {
        let chartData = generateChartData()
        let maxFrequency = chartData?.map() { return $0.maxFrequency ?? 0 }.max() ?? 0
        let maxTemperature = chartData?.map() { return $0.maxTemperature ?? 0 }.max() ?? 0
        if chartData != nil {
            Section("Core \(index)") {
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
    CpuCharts(index: 0)
}
