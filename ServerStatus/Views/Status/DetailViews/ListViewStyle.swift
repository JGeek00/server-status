import SwiftUI

struct ListViewStyle: ViewModifier {
    var isPlain: Bool
    
    @ViewBuilder func body(content: Content) -> some View {
        if isPlain {
            content.listStyle(.plain)
        } else {
            content.listStyle(.grouped)
        }
    }
}
