import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("Configure the CPU widget.")

    @Parameter(title: "Show updated time", default: true)
    var showUpdatedTime: Bool
}
