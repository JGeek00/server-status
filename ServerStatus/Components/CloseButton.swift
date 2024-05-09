import SwiftUI

struct CloseButton: View {
    let onClose: () -> Void
        
    var body: some View {
        Button {
            onClose()
        } label: {
            HStack {
                Spacer()
                Image(systemName: "xmark")
                    .foregroundColor(.foreground.opacity(0.5))
                    .font(.system(size: 11))
                    .fontWeight(Font.Weight.bold)
            }
            
        }
        .frame(width: 28, height: 28)
        .background(Color.foreground.opacity(0.1))
        .cornerRadius(50)
    }
}

#Preview {
    CloseButton(onClose: {})
}
