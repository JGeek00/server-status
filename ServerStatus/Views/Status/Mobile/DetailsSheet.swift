import SwiftUI

struct DetailsSheet: View {
    let hardwareItem: Enums.HardwareItem
    let onCloseSheet: () -> Void
    
    var body: some View {
        NavigationView {
            switch hardwareItem {
                case .cpu:
                    CpuDetail(onCloseSheet: onCloseSheet)
                case .memory:
                    MemoryDetail(onCloseSheet: onCloseSheet)
                case .storage:
                    StorageDetail(onCloseSheet: onCloseSheet)
                case .network:
                    NetworkDetail(onCloseSheet: onCloseSheet)
                case .systemInfo:
                    SystemDetail(onCloseSheet: onCloseSheet)
            }
        }
    }
}
