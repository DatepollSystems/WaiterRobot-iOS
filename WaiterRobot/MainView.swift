//
//  MainView.swift
//  WaiterRobot
//
//  Created by Alexander Kauer on 29.12.23.
//

import shared
import SwiftUI
import UIPilot

struct MainView: View {
    @State private var snackBarMessage: String?
    @State private var showUpdateAvailableAlert: Bool = false
    @StateObject private var navigator: UIPilot<Screen> = UIPilot(initial: Screen.RootScreen.shared, debug: true)
    @StateObject private var strongVM = ObservableViewModel(vm: koin.rootVM())

    private var selectedScheme: ColorScheme? {
        switch strongVM.state.selectedTheme {
        case .dark:
            .dark
        case .light:
            .light
        default:
            nil
        }
    }

    var body: some View {
        unowned let vm = strongVM

        ZStack {
            UIPilotHost(navigator) { route in
                switch route {
                case is Screen.RootScreen: RootScreen(strongVM: vm)
                case is Screen.LoginScannerScreen: LoginScannerScreen()
                case is Screen.SwitchEventScreen: SwitchEventScreen()
                case is Screen.SettingsScreen: SettingsScreen()
                case is Screen.UpdateApp: UpdateAppScreen()
                case let screen as Screen.RegisterScreen: RegisterScreen(createToken: screen.createToken)
                case let screen as Screen.TableDetailScreen: TableDetailScreen(table: screen.table)
                case let screen as Screen.OrderScreen: OrderScreen(table: screen.table, initialItemId: screen.initialItemId)
                case let screen as Screen.BillingScreen: BillingScreen(table: screen.table)
                default:
                    Text("No view defined for \(route.description)") // TODO:
                    Button {
                        navigator.pop()
                    } label: {
                        Text("Back")
                    }.onAppear {
                        koin.logger(tag: "WaiterRobotApp").e { "No view defined for \(route.description)" }
                    }
                }
            }
        }
        .preferredColorScheme(selectedScheme)
        .overlay(alignment: .bottom) {
            if let message = snackBarMessage {
                ZStack {
                    HStack {
                        Text(message)
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            snackBarMessage = nil
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
            }
        }
        .handleSideEffects(of: vm, navigator) { effect in
            switch effect {
            case let snackBar as RootEffect.ShowSnackBar:
                snackBarMessage = snackBar.message
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    snackBarMessage = nil
                }
            default:
                return false
            }
            return true
        }
        .onOpenURL { url in
            vm.actual.onDeepLink(url: url.absoluteString)
        }
        .alert(
            localize.app.updateAvailable.title(),
            isPresented: $showUpdateAvailableAlert
        ) {
            Button(localize.dialog.cancel(), role: .cancel) {
                showUpdateAvailableAlert = false
            }

            Button(localize.app.forceUpdate.openStore(value0: "App Store")) {
                guard let storeUrl = VersionChecker.shared.storeUrl,
                      let url = URL(string: storeUrl)
                else {
                    return
                }

                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } message: {
            Text(localize.app.updateAvailable.message())
        }
        .onAppear {
            VersionChecker.shared.checkVersion {
                showUpdateAvailableAlert = true
            }
        }
        .tint(.main)
    }
}

#Preview {
    MainView()
}