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
        let nilEntry = WidgetEntry(date: Date(), configuration: configuration, data: nil)
        
        let nextUpdate = Calendar.current.date(
            byAdding: DateComponents(minute: configuration.refreshTime.value),
            to: Date()
        )!
        
        let fetchedData = await fetchStatus(serverInstance: configuration.serverInstance.value)
        guard let data = fetchedData else { return
            Timeline(entries: [nilEntry], policy: .after(nextUpdate))
        }
        
        let entry = WidgetEntry(date: Date(), configuration: configuration, data: data)
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let data: StatusModel?
}

struct MemoryWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = geometry.size.width - 16
            VStack(alignment: .leading) {
                Text("Memory")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                if entry.data?.memory?.total != nil {
                    Spacer()
                        .frame(height: 4)
                    Text("\(String(describing: formatMemoryValue(value: entry.data!.memory!.total))) GB")
                        .font(.system(size: 12))
                }
                if entry.configuration.showUpdatedTime == true {
                    Spacer()
                        .frame(height: 4)
                    Text("Updated at \(Text(entry.date, format: Date.FormatStyle().hour().minute()))")
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                }
                Spacer()
                if entry.data != nil {
                    HStack {
                        if entry.data?.memory?.total != nil && entry.data?.memory?.available != nil {
                            let used = entry.data!.memory!.total! - entry.data!.memory!.available!
                            let perc = (Double(used)/Double(entry.data!.memory!.total!))*100.0
                            Gauge(
                                value: "\(Int(perc))%",
                                percentage: perc,
                                icon: Image(systemName: "memorychip"),
                                colors: gaugeColors
                            )
                            .frame(width: width/2, height: width/2)
                        }
                        Spacer()
                        if entry.data?.memory?.available != nil {
                            VStack(alignment: .center) {
                                Text("\(String(describing: formatMemoryValue(value: entry.data!.memory!.available))) GB")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                Spacer()
                                    .frame(height: 4)
                                Text("available")
                                    .font(.system(size: 12))
                            }
                        }
                        
                    }
                }
                else {
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Image(systemName: "exclamationmark.circle")
                                .font(.system(size: 24))
                            Spacer()
                                .frame(height: 4)
                            Text("Cannot update status")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                }
            }
        })
    }
}

struct MemoryWidget: Widget {
    let kind: String = "MemoryWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MemoryWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .description("Memory status")
        .configurationDisplayName("Memory")
        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var enabledUpdatedTime: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.showUpdatedTime = true
        return intent
    }
    
    fileprivate static var disabledUpdatedTime: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.showUpdatedTime = false
        return intent
    }
}

#Preview(as: .systemSmall) {
    MemoryWidget()
} timeline: {
    WidgetEntry(date: .now, configuration: .enabledUpdatedTime, data: mockData())
    WidgetEntry(date: .now, configuration: .disabledUpdatedTime, data: mockData())
}
