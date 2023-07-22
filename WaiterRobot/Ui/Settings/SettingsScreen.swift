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
                        title: localize.settings.logout.action(),
                        subtitle: "\"\(CommonApp.shared.settings.organisationName)\" / \"\(CommonApp.shared.settings.waiterName)\"",
                        action: {
                            showConfirmLogout = true
                        }
                    )

                    SettingsItem(
                        icon: "arrow.triangle.2.circlepath",
                        title: localize.settings.refresh.title(),
                        subtitle: localize.settings.refresh.desc(),
                        action: vm.actual.refreshAll
                    )

                    SettingsItem(
                        icon: "person.3",
                        title: localize.switchEvent.title(),
                        subtitle: CommonApp.shared.settings.eventName,
                        action: vm.actual.switchEvent
                    )
                }

                Section {
                    SwitchThemeView(initial: vm.state.currentAppTheme, onChange: vm.actual.switchTheme)
                }

                Section {
                    Link(localize.settings.privacyPolicy(), destination: URL(string: CommonApp.shared.privacyPolicyUrl)!)
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
        .navigationTitle(localize.settings.title())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showConfirmLogout = true
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .confirmationDialog(localize.settings.logout.title(value0: CommonApp.shared.settings.organisationName), isPresented: $showConfirmLogout, titleVisibility: .visible) {
            Button(localize.settings.logout.action(), role: .destructive, action: vm.actual.logout)
            Button(localize.settings.keepLoggedIn(), role: .cancel, action: { showConfirmLogout = false })
        } message: {
            Text(localize.settings.logout.desc(value0: CommonApp.shared.settings.organisationName))
        }
        .handleSideEffects(of: vm, navigator)
    }
}
