import SwiftUI

struct NoInstancesView: View {
    @StateObject var instanceFormModel = InstanceFormViewModel()
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var scheme
    
    @State var showSettingsSheet = false
    
    var body: some View {
        VStack {
            Text("No instances available")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            Spacer().frame(height: 20)
            Text("Create a new instance to begin.")
                .multilineTextAlignment(.center)
            Spacer().frame(height: 50)
            HStack {
                Button {
                    instanceFormModel.reset()
                    instanceFormModel.modalOpen.toggle()
                } label: {
                    Label {
                        Text("Add instance")
                            .foregroundColor(.white)
                    } icon: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }

                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(50)
                .padding(10)
                Spacer()
                    .frame(width: 20)
                if horizontalSizeClass == .regular {
                    Button {
                        showSettingsSheet.toggle()
                    } label: {
                        Label {
                            Text("Settings")
                                .foregroundColor(.white)
                        } icon: {
                            Image(systemName: "gear")
                                .foregroundColor(.white)
                        }

                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(50)
                    .padding(10)
                }
            }
        }
        .padding()
        .sheet(isPresented: $instanceFormModel.modalOpen, content: {
            InstanceFormView(instanceFormModel: instanceFormModel)
        })
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
                if horizontalSizeClass == .regular {
                    Button {
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .sheet(isPresented: $showSettingsSheet, content: {
            SettingsView(scheme: scheme) {
                showSettingsSheet.toggle()
            }
        })
    }
}

#Preview {
    NoInstancesView()
}
