import SwiftUI

struct TabletViewHardwareEntry: View {
    let image: String
    let label: String
    let hardwareItem: Enums.HardwareItem
    let value1: String
    let value1Image: String
    let value2: String?
    let value2Image: String?
    
    @EnvironmentObject var statusModel: StatusViewModel
    @EnvironmentObject var appConfig: AppConfigViewModel
    
    var body: some View {
        let foregroundColor = statusModel.selectedHardwareItem == hardwareItem
        ? Color.white
        : appConfig.getTheme() == ColorScheme.dark ? Color.white : Color.black
        HStack {
            Button {
                withAnimation(nil) {
                    statusModel.selectedHardwareItem = hardwareItem
                }
            } label: {
                HStack {
                    Image(systemName: image)
                        .font(.system(size: 34))
                        .fontWeight(.medium)
                        .frame(width: 38)
                        .foregroundColor(foregroundColor)
                    Spacer().frame(width: 16)
                    VStack(alignment: .leading) {
                        Text(label)
                            .font(.system(size: 24))
                            .foregroundColor(foregroundColor)
                        Spacer().frame(height: 8)
                        HStack {
                            HStack {
                                Image(systemName: value1Image)
                                    .foregroundColor(foregroundColor)
                                Text(value1)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .foregroundColor(foregroundColor)
                            }
                            if value2 != nil && value2Image != nil {
                                Spacer().frame(width: 16)
                                HStack {
                                    Image(systemName: value2Image!)
                                        .foregroundColor(foregroundColor)
                                    Text(value2!)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .foregroundColor(foregroundColor)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(statusModel.selectedHardwareItem == hardwareItem ? Color.blue : nil)
        }
        .cornerRadius(8)
        .padding(.horizontal, 8)
    }
}
