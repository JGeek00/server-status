import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), configuration: ConfigurationAppIntent(), data: mockData())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> WidgetEntry {
        WidgetEntry(date: Date(), configuration: configuration, data: mockData())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<WidgetEntry> {
        
        let entry = WidgetEntry(date: Date(), configuration: configuration, data: mockData())
        return Timeline(entries: [entry], policy: .atEnd)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let data: StatusModel?
}

struct CpuWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let cpuMaxTemp = entry.data?.cpu?.cpuCores?.map({ return $0.temperatures?.first ?? 0 }).max()
        let cpuMaxTempLimit = entry.data?.cpu?.cpuCores?.map({ return $0.temperatures?.last ?? 0 }).max()
        
        GeometryReader(content: { geometry in
            let width = geometry.size.width - 16
            VStack(alignment: .leading) {
                Text("CPU")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Spacer()
                    .frame(height: 4)
                if entry.data?.cpu?.model != nil {
                    Text(entry.data!.cpu!.model!)
                        .font(.system(size: 12))
                }
                Spacer()
                    .frame(height: 4)
                Text("Updated at ")
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
                + Text(entry.date, format: Date.FormatStyle().hour().minute())
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
                Spacer()
                HStack {
                    if entry.data?.cpu?.utilisation != nil {
                        Gauge(
                            value: "\(String(describing: Int(entry.data!.cpu!.utilisation!*100)))%",
                            percentage: entry.data!.cpu!.utilisation!*100,
                            icon: Image(systemName: "cpu"),
                            colors: gaugeColors
                        )
                        .frame(width: width/2, height: width/2)
                    }
                    Spacer()
                    if cpuMaxTemp != nil {
                        Gauge(
                            value: "\(String(describing: cpuMaxTemp!))ºC",
                            percentage: Double((cpuMaxTemp! * cpuMaxTempLimit!)/100),
                            icon: Image(systemName: "thermometer.medium"),
                            colors: gaugeColors
                        )
                        .frame(width: width/2, height: width/2)
                    }
                    
                }
            }
        })
    }
}

struct CpuWidget: Widget {
    let kind: String = "CpuWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CpuWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .description("CPU status")
        .configurationDisplayName("CPU")
        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    CpuWidget()
} timeline: {
    WidgetEntry(date: .now, configuration: .smiley, data: mockData())
    WidgetEntry(date: .now, configuration: .starEyes, data: mockData())
}
