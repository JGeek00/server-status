import SwiftUI
import SafariServices

struct SettingsView: View {
    @EnvironmentObject var appConfig: AppConfigViewModel
    @EnvironmentObject var instancesModel: InstancesViewModel
    @StateObject var settingsModel = SettingsViewModel()
    @StateObject var instanceFormModel = InstanceFormViewModel()
    @EnvironmentObject var statusModel: StatusViewModel
    
    var body: some View {
        let valueColor = appConfig.getTheme() == ColorScheme.dark ? Color(red: 129/255, green: 129/255, blue: 134/255) : Color(red: 138/255 , green: 138/255, blue: 142/255)
        NavigationStack {
            Group {
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
                    Section("App settings") {
                        Toggle("Show server URL on details screen", isOn: $appConfig.showUrlDetailsScreen)
                            .onChange(of: appConfig.showUrlDetailsScreen) { oldValue, newValue in
                                appConfig.updateSettingsToggle(key: StorageKeys.showServerUrlDetails, value: newValue)
                            }
                    }
                    Section {
                        NavigationLink("Give a tip to the developer", value: Routes.SettingsRoutes.tips)
                        Button {
                            settingsModel.safariOpen.toggle()
                        } label: {
                            HStack {
                                Text("Check \"Status\" repository")
                                    .foregroundColor(appConfig.getTheme() == ColorScheme.dark ? Color.white : Color.black)
                                Spacer()
                                Image(systemName: "link")
                                    .foregroundColor(valueColor)
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
                            .foregroundColor(valueColor)
                        }
                    } header: {
                        Text("About the app")
                    } footer: {
                        HStack {
                            Spacer()
                            Text("Created on 🇪🇸 by JGeek00")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 16))
                            Spacer()
                        }
                        .padding(.top, 8)
                    }

                }
                .navigationTitle("Settings")
            }
            .navigationDestination(for: Routes.SettingsRoutes.self) { item in
                switch item {
                    case .tips:
                        TipsView()
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
                instancesModel.deleteInstance(
                    instance: settingsModel.selectedItemDelete!,
                    instancesModel: instancesModel,
                    statusModel: statusModel
                )
                settingsModel.selectedItemDelete = nil
            } label: {
                Text("Delete")
            }
        }, message: {
            Text("Are you sure you want to delete this instance?")
        })
    }
}
