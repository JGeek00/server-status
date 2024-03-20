import SwiftUI

struct DetailsSheet: View {
    let hardwareItem: Enums.HardwareItem
    let onCloseSheet: () -> Void
    
    var body: some View {
        switch hardwareItem {
            case .cpu:
                NavigationStack {
                    CpuDetail(onCloseSheet: onCloseSheet)
                }
            case .memory:
                NavigationStack {
                    MemoryDetail(onCloseSheet: onCloseSheet)
                }
            case .storage:
                NavigationStack {
                    StorageDetail(onCloseSheet: onCloseSheet)
                }
            case .network:
                NavigationStack {
                    NetworkDetail(onCloseSheet: onCloseSheet)
                }
        }
    }
}
