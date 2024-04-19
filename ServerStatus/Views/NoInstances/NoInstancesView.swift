import SwiftUI

struct NoInstancesView: View {
    @StateObject var instanceFormModel = InstanceFormViewModel()
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
        }
        .navigationTitle("Instances")
        .padding()
        .sheet(isPresented: $instanceFormModel.modalOpen, content: {
            InstanceFormView(instanceFormModel: instanceFormModel)
        })
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
                if horizontalSizeClass == .regular {
                    Button {
                        
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

#Preview {
    NoInstancesView()
}
