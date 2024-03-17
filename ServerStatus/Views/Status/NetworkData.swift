import SwiftUI

struct NetworkData: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Image(systemName: "network")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                Spacer().frame(width: 16)
                VStack(alignment: .leading) {
                    Text("Network")
                        .font(.system(size: 24))
                    Spacer().frame(height: 4)
                    Text("1.00 Gbit/s")
                        .font(.system(size: 16))
                }
                Spacer()
            }
            Spacer().frame(height: 24)
            HStack {
                Spacer()
                VStack {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 40))
                    Spacer().frame(height: 16)
                    Text("50 Kbit/s")
                    Spacer().frame(height: 8)
                    Text("5 KB/s")
                }
                Spacer()
                VStack {
                    Image(systemName: "arrow.up.circle")
                        .font(.system(size: 40))
                    Spacer().frame(height: 16)
                    Text("50 Kbit/s")
                    Spacer().frame(height: 8)
                    Text("5 KB/s")
                }
                Spacer()
            }
        }
    }
}
