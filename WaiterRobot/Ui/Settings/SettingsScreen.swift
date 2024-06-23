import shared
import SwiftUI
import UIPilot
import WRCore

struct SettingsScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @State private var showConfirmLogout = false

    @StateObject private var viewModel = ObservableSettingsViewModel()

    var body: some View {
        switch viewModel.state.viewState {
        case is ViewState.Loading:
            ProgressView()
        case is ViewState.Idle:
            content()
        case let error as ViewState.Error:
            content()
                .alert(isPresented: Binding.constant(true)) {
                    Alert(
                        title: Text(error.title),
                        message: Text(error.message),
                        dismissButton: .cancel(Text("OK"), action: error.onDismiss)
                    )
                }
        default:
            fatalError("Unexpected ViewState: \(viewModel.state.viewState.description)")
        }
    }

    private func content() -> some View {
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
                    action: {
                        viewModel.actual.refreshAll()
                    }
                )

                SettingsItem(
                    icon: "person.3",
                    title: localize.switchEvent.title(),
                    subtitle: CommonApp.shared.settings.eventName,
                    action: {
                        viewModel.actual.switchEvent()
                    }
                )
            }

            Section {
                SwitchThemeView(
                    initial: viewModel.state.currentAppTheme,
                    onChange: viewModel.actual.switchTheme
                )
            }

            Section {
                Link(localize.settings.privacyPolicy(), destination: URL(string: CommonApp.shared.privacyPolicyUrl)!)
            }

            HStack {
                Spacer()
                Text(viewModel.state.versionString)
                    .font(.footnote)
                Spacer()
            }
            .listRowBackground(Color.clear)
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
            Button(localize.settings.logout.action(), role: .destructive, action: { viewModel.actual.logout() })
            Button(localize.settings.keepLoggedIn(), role: .cancel, action: { showConfirmLogout = false })
        } message: {
            Text(localize.settings.logout.desc(value0: CommonApp.shared.settings.organisationName))
        }
        .withViewModel(viewModel, navigator)
    }
}
