import shared
import SwiftUI
import UIPilot
import WRCore

struct SettingsScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @State private var showConfirmLogout = false
    @State private var showConfirmSkipMoneyBackDialog = false

    @StateObject private var viewModel = ObservableSettingsViewModel()

    var body: some View {
        List {
            general()

            payment()

            Section(header: Text(localize.settings_about_title())) {
                Link(localize.settings_about_privacyPolicy(), destination: URL(string: CommonApp.shared.privacyPolicyUrl)!)
            }

            HStack {
                Spacer()
                Text(viewModel.state.versionString())
                    .font(.footnote)
                Spacer()
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle(localize.settings_title())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showConfirmLogout = true
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .confirmationDialog(
            localize.settings_general_logout_title(CommonApp.shared.settings.organisationName),
            isPresented: $showConfirmLogout,
            titleVisibility: .visible
        ) {
            Button(localize.settings_general_logout_action(), role: .destructive, action: { viewModel.actual.logout() })
            Button(localize.settings_general_logout_cancel(), role: .cancel, action: { showConfirmLogout = false })
        } message: {
            Text(localize.settings_general_logout_desc(CommonApp.shared.settings.organisationName))
        }
        .confirmationDialog(
            localize.settings_payment_skipMoneyBackDialog_title(),
            isPresented: $showConfirmSkipMoneyBackDialog,
            titleVisibility: .visible
        ) {
            Button(localize.settings_payment_skipMoneyBackDialog_confirm_action(), role: .destructive) {
                viewModel.actual.toggleSkipMoneyBackDialog(value: true, confirmed: true)
            }
            Button(localize.dialog_cancel(), role: .cancel) {
                showConfirmSkipMoneyBackDialog = false
            }
        } message: {
            Text(localize.settings_payment_skipMoneyBackDialog_confirm_desc())
        }
        .withViewModel(viewModel, navigator) { effect in
            switch onEnum(of: effect) {
            case .confirmSkipMoneyBackDialog:
                showConfirmSkipMoneyBackDialog = true
            }

            return true
        }
    }

    private func general() -> some View {
        Section(header: Text(localize.settings_general_title())) {
            SettingsItem(
                icon: "rectangle.portrait.and.arrow.right",
                title: localize.settings_general_logout_action(),
                subtitle: "\"\(CommonApp.shared.settings.organisationName)\" / \"\(CommonApp.shared.settings.waiterName)\"",
                onClick: {
                    showConfirmLogout = true
                }
            )

            SettingsItem(
                icon: "person.3",
                title: localize.switchEvent_title(),
                subtitle: CommonApp.shared.settings.eventName,
                onClick: {
                    viewModel.actual.switchEvent()
                }
            )

            SwitchThemeView(
                initial: viewModel.state.currentAppTheme,
                onChange: viewModel.actual.switchTheme
            )

            SettingsItem(
                icon: "arrow.triangle.2.circlepath",
                title: localize.settings_general_refresh_title(),
                subtitle: localize.settings_general_refresh_desc(),
                onClick: {
                    viewModel.actual.refreshAll()
                }
            )
        }
    }

    private func payment() -> some View {
        Section(header: Text(localize.settings_payment_title())) {
            SettingsItem(
                icon: "dollarsign.arrow.circlepath",
                title: localize.settings_payment_skipMoneyBackDialog_title(),
                subtitle: localize.settings_payment_skipMoneyBackDialog_desc(),
                action: {
                    Toggle(
                        isOn: .init(
                            get: { viewModel.state.skipMoneyBackDialog },
                            set: { newValue in
                                let kotlinBool = KotlinBoolean(value: newValue)
                                viewModel.actual.toggleSkipMoneyBackDialog(value: kotlinBool, confirmed: false)
                            }
                        ),
                        label: {}
                    ).labelsHidden()
                },
                onClick: {
                    viewModel.actual.toggleSkipMoneyBackDialog(value: nil, confirmed: false)
                }
            )

            SettingsItem(
                icon: "checkmark.square",
                title: localize.settings_payment_selectAllProductsByDefault_title(),
                subtitle: localize.settings_payment_selectAllProductsByDefault_desc(),
                action: {
                    Toggle(
                        isOn: .init(
                            get: { viewModel.state.paymentSelectAllProductsByDefault },
                            set: { newValue in
                                let kotlinBool = KotlinBoolean(value: newValue)
                                viewModel.actual.togglePaymentSelectAllProductsByDefault(value: kotlinBool)
                            }
                        ),
                        label: {}
                    ).labelsHidden()
                },
                onClick: {
                    viewModel.actual.togglePaymentSelectAllProductsByDefault(value: nil)
                }
            )
        }
    }
}
