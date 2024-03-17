import SwiftUI

struct NoInstancesView: View {
    @StateObject var createInstanceModel = CreateInstanceViewModel()
    @StateObject var settingsModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            Text("No instances available")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            Spacer().frame(height: 20)
            Text("Create a new instance to begin.")
                .multilineTextAlignment(.center)
            Spacer().frame(height: 50)
            Button {
                createInstanceModel.reset()
                createInstanceModel.modalOpen.toggle()
            } label: {
                Label {
                    Text("Add instance")
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }

            }
            .padding(10)
            .background(Color.blue)
            .cornerRadius(50)
        }
        .navigationTitle("Instances")
        .toolbar(content: {
            ToolbarItem {
                Button {
                    settingsModel.modalOpen.toggle()
                } label: {
                    Image(systemName: "gear")
                }
            }
        })
        .padding()
        .sheet(isPresented: $createInstanceModel.modalOpen, content: {
            CreateInstanceView(createInstanceModel: createInstanceModel)
        }).sheet(isPresented: $settingsModel.modalOpen, content: {
            SettingsView(settingsModel: settingsModel)
        })
    }
}

#Preview {
    NoInstancesView()
}
