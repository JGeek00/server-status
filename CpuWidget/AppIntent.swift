import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("Configure the CPU widget.")

    @Parameter(title: "Show updated time", default: true)
    var showUpdatedTime: Bool
    
    @Parameter(title: "Refresh time", default: 30)
    var refreshTime: Int
}
