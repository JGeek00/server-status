import SwiftUI

struct CloseButton: View {
    let onClose: () -> Void
        
    var body: some View {
        Button {
            onClose()
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.foreground.opacity(0.5))
                .font(.system(size: 14))
                .fontWeight(Font.Weight.bold)
        }
        .buttonStyle(.bordered)
        .clipShape(Circle())
    }
}

#Preview {
    CloseButton(onClose: {})
}
