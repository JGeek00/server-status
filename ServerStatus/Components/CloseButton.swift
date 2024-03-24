import SwiftUI

struct CloseButton: View {
    let onClose: () -> Void
    
    @EnvironmentObject private var appConfig: AppConfigViewModel
    
    var body: some View {
        Button {
            onClose()
        } label: {
            HStack {
                Spacer()
                Image(systemName: "xmark")
                    .foregroundColor(
                        appConfig.getTheme() == ColorScheme.dark
                            ? Color.white.opacity(0.5)
                            : Color.black.opacity(0.5)
                    )
                    .font(.system(size: 11))
                    .fontWeight(Font.Weight.bold)
            }
            
        }
        .frame(width: 28, height: 28)
        .background(
            appConfig.getTheme() == ColorScheme.dark
                ? Color.white.opacity(0.1)
                : Color.black.opacity(0.1)
        )
        .cornerRadius(50)
    }
}

#Preview {
    CloseButton(onClose: {})
}
