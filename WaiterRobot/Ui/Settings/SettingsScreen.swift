import shared
import SwiftUI
import UIPilot

struct SettingsScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @State private var showConfirmLogout = false
    @StateObject private var strongVM = ObservableViewModel(vm: koin.settingsVM())

    var body: some View {
        unowned let vm = strongVM

        ScreenContainer(vm.state) {
            List {
                Section {
                    SettingsItem(
                        icon: "rectangle.portrait.and.arrow.right",
                        title: localizeString.settings.logout.action(),
                        subtitle: "\"\(CommonApp.shared.settings.organisationName)\" / \"\(CommonApp.shared.settings.waiterName)\"",
                        action: {
                            showConfirmLogout = true
                        }
                    )

                    SettingsItem(
                        icon: "arrow.triangle.2.circlepath",
                        title: localizeString.settings.refresh.title(),
                        subtitle: localizeString.settings.refresh.desc(),
                        action: vm.actual.refreshAll
                    )

                    SettingsItem(
                        icon: "person.3",
                        title: localizeString.switchEvent.title(),
                        subtitle: CommonApp.shared.settings.eventName,
                        action: vm.actual.switchEvent
                    )
                }

                Section {
                    SwitchThemeView(initial: vm.state.currentAppTheme, onChange: vm.actual.switchTheme)
                }

                Section {
                    Link(localizeString.settings.privacyPolicy(), destination: URL(string: CommonApp.shared.privacyPolicyUrl)!)
                }

                HStack {
                    Spacer()
                    Text(vm.state.versionString)
                        .font(.footnote)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(localizeString.settings.title())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showConfirmLogout = true
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .confirmationDialog(localizeString.settings.logout.title(value0: CommonApp.shared.settings.organisationName), isPresented: $showConfirmLogout, titleVisibility: .visible) {
            Button(localizeString.settings.logout.action(), role: .destructive, action: vm.actual.logout)
            Button(localizeString.settings.keepLoggedIn(), role: .cancel, action: { showConfirmLogout = false })
        } message: {
            Text(localizeString.settings.logout.desc(value0: CommonApp.shared.settings.organisationName))
        }
        .handleSideEffects(of: vm, navigator)
    }
}
