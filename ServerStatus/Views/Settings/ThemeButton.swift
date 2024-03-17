//
//  ThemeButton.swift
//  ServerStatus
//
//  Created by Juan Gilsanz Polo on 17/3/24.
//

import SwiftUI

struct ThemeButton: View {
    let thisOption: Enums.Theme
    @Binding var selectedOption: Enums.Theme
    let onSelect: (Enums.Theme) -> Void
    
    @EnvironmentObject private var appConfig: AppConfigViewModel
    
    func labelIcon() -> [String] {
        if (thisOption == Enums.Theme.system) {
            return ["iphone", "System defined"]
        }
        else if (thisOption == Enums.Theme.light) {
            return ["sun.max", "Light"]
        }
        else if (thisOption == Enums.Theme.dark) {
            return ["moon", "Dark"]
        }
        else {
            return []
        }
    }
    
    var body: some View {
        let data = labelIcon()
        Button {
            onSelect(thisOption)
        } label: {
            HStack {
                HStack {
                    Image(systemName: data[0])
                        .foregroundColor(appConfig.getTheme() == ColorScheme.dark ? Color.white : Color.black)
                    Spacer().frame(width: 16)
                    Text(data[1])
                        .foregroundColor(appConfig.getTheme() == ColorScheme.dark ? Color.white : Color.black)
                }
                Spacer()
                if selectedOption == thisOption {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
