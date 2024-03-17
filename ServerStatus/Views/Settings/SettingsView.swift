import SwiftUI
import SafariServices

struct SettingsView: View {
    @EnvironmentObject var appConfig: AppConfigViewModel
    @EnvironmentObject var instancesModel: InstancesViewModel
    @ObservedObject var settingsModel: SettingsViewModel
    @StateObject var instanceFormModel = InstanceFormViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ServersInstancesList(instanceFormModel: instanceFormModel, settingsModel: settingsModel)
                Section("Theme") {
                    ThemeButton(
                        thisOption: Enums.Theme.system,
                        selectedOption: $appConfig.theme,
                        onSelect: { value in appConfig.updateTheme(selectedTheme: value)}
                    )
                    ThemeButton(
                        thisOption: Enums.Theme.light,
                        selectedOption: $appConfig.theme,
                        onSelect: { value in appConfig.updateTheme(selectedTheme: value)}
                    )
                    ThemeButton(
                        thisOption: Enums.Theme.dark,
                        selectedOption: $appConfig.theme,
                        onSelect: { value in appConfig.updateTheme(selectedTheme: value)}
                    )
                }
                Section("About the app") {
                    Button {
                        settingsModel.safariOpen.toggle()
                    } label: {
                        HStack {
                            Text("Check \"Status\" repository")
                                .foregroundColor(appConfig.getTheme() == ColorScheme.dark ? Color.white : Color.black)
                            Spacer()
                            Image(systemName: "link")
                                .foregroundColor(appConfig.getTheme() == ColorScheme.dark ? Color.white : Color.black)
                        }
                    }
                    HStack {
                        Text("App version")
                        Spacer()
                        Text(
                            Bundle.main.infoDictionary?["CFBundleShortVersionString"] != nil
                                ? Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                                : "Unknown"
                        )
                        
                    }
                    HStack {
                        Text("Created by")
                        Spacer()
                        Text(Strings.creator)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        settingsModel.modalOpen.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .fontWeight(Font.Weight.bold)
                        }
                            
                    }
                        .frame(width: 28, height: 28)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(50)
                }
            }
        }
        .preferredColorScheme(appConfig.getTheme())
        .fullScreenCover(isPresented: $settingsModel.safariOpen, content: {
            SFSafariViewWrapper(url: URL(string: Urls.statusRepo)!).ignoresSafeArea()
        })
        .sheet(isPresented: $instanceFormModel.modalOpen, content: {
            InstanceFormView(instanceFormModel: instanceFormModel)
        })
        .alert("Delete instance", isPresented:$settingsModel.confirmDeleteOpen, actions: {
            Button(role: .destructive) {
                instancesModel.deleteInstance(instance: settingsModel.selectedItemDelete!)
                settingsModel.selectedItemDelete = nil
            } label: {
                Text("Delete")
            }
        }, message: {
            Text("Are you sure you want to delete this instance?")
        })
    }
}
