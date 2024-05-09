import SwiftUI

struct SystemDetail: View {
    let onCloseSheet: (() -> Void)?
    
    var body: some View {
        if onCloseSheet != nil {
            SystemList(onCloseSheet: onCloseSheet)
                .listStyle(DefaultListStyle())
        }
        else {
            SystemList(onCloseSheet: onCloseSheet)
                .listStyle(InsetListStyle())
        }
    }
}

struct SystemList: View {
    let onCloseSheet: (() -> Void)?
    
    @EnvironmentObject var statusModel: StatusViewModel
    @EnvironmentObject var instancesModel: InstancesViewModel
    
    @AppStorage(StorageKeys.theme, store: UserDefaults(suiteName: groupId)) private var theme: Enums.Theme = .system
    
    var body: some View {
        let data = statusModel.status?.last
        let valueColor = theme == .dark ? Color(red: 129/255, green: 129/255, blue: 134/255) : Color(red: 138/255 , green: 138/255, blue: 142/255)
        List {
            HStack {
                Text("Device name")
                Spacer()
                Text(data?.host?.hostname ?? "N/A")
                    .foregroundColor(valueColor)
            }
            HStack {
                Text("Operating system")
                Spacer()
                Text(data?.host?.os ?? "N/A")
                    .foregroundColor(valueColor)
            }
            HStack {
                Text("Uptime")
                Spacer()
                Text(data?.host?.uptime != nil ? formatDuration(timestamp: data!.host!.uptime!) : "N/A")
                    .foregroundColor(valueColor)
            }
            HStack {
                Text("App memory")
                Spacer()
                Text(data?.host?.appMemory != nil ? cacheValue(value: Int(data!.host!.appMemory!)) : "N/A")
                    .foregroundColor(valueColor)
            }
            HStack {
                Text("Load averages")
                Spacer()
                Text(data?.host?.loadavg != nil ? data!.host!.loadavg!.map(){formatNumber(value: NSNumber(value: $0)) ?? String($0)}.joined(separator: "  |  ") : "N/A")
                    .foregroundColor(valueColor)
            }
        }
        .contentMargins(.top, 16)
        .navigationTitle("System details")
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
