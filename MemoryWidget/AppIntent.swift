import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("Configure the memory widget.")
    
    @Parameter(title: "Show updated time", default: true)
    var showUpdatedTime: Bool
    
    @Parameter(title: "Refresh time")
    var refreshTime: RefreshTime
    
    @Parameter(title: "Server instance")
    var serverInstance: Instances
}

struct RefreshTime: AppEntity {
    let id: String
    let value: Int
    let label: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Refresh time"
    static var defaultQuery = RefreshTimeQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(label)")
    }
    
    static let refreshOptions: [RefreshTime] = [
        RefreshTime(id: "15minutes", value: 15, label: "15 minutes"),
        RefreshTime(id: "30minutes", value: 30, label: "30 minutes"),
        RefreshTime(id: "45 minutes", value: 45, label: "45 minutes"),
        RefreshTime(id: "60 minutes", value: 60, label: "60 minutes")
    ]
}

struct RefreshTimeQuery: EntityQuery {
    func entities(for identifiers: [RefreshTime.ID]) async throws -> [RefreshTime] {
        RefreshTime.refreshOptions.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [RefreshTime] {
        RefreshTime.refreshOptions
    }
    
    func defaultResult() async -> RefreshTime? {
        try? await suggestedEntities()[1]
    }
}

struct Instances: AppEntity {
    let id: String
    let value: ServerInstances
    let label: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Server instances"
    static var defaultQuery = ServerInstancesQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(label)")
    }
}

struct ServerInstancesQuery: EntityQuery {
    func getInstances() -> [ServerInstances] {
        guard let instances = fetchInstancesCoreData() else { return [] }
        return instances.filter() { $0.id != nil && $0.name != nil && $0.ipDomain != nil }
    }
    
    func entities(for identifiers: [Instances.ID]) async throws -> [Instances] {
        return getInstances().map() { Instances(id: $0.id!, value: $0, label: $0.name!) }.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [Instances] {
        return getInstances().map() { Instances(id: $0.id!, value: $0, label: $0.name!) }
    }
    
    func defaultResult() async -> Instances? {
        try? await suggestedEntities().first
    }
}
