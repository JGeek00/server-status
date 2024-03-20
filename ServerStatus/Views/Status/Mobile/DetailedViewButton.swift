import SwiftUI

struct DetailedViewButton: View {
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(LocalizedStringKey("DETAILED VIEW"))
                .foregroundStyle(Color.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .font(.system(size: 12))
                .fontWeight(.bold)
        }
        .background(Color.blue)
        .cornerRadius(50)
    }
}

#Preview {
    DetailedViewButton(onTap: {})
}
