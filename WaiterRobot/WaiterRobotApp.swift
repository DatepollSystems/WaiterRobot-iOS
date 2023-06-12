import SwiftUI
import UIPilot
import shared

@main
struct WaiterRobotApp: App {
  @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
  
  @State private var snackBarMessage: String? = nil
  @State private var showUpdateAvailableAlert: Bool = false
  @StateObject private var navigator: UIPilot<Screen> = UIPilot(initial: Screen.RootScreen.shared, debug: true)
  @StateObject private var strongVM = ObservableViewModel(vm: koin.rootVM())
  
  private var selectedScheme: ColorScheme? {
    switch strongVM.state.selectedTheme {
    case .dark:
      return .dark
    case .light:
      return .light
    default:
      return nil
    }
  }
  
  var body: some Scene {
    unowned let vm = strongVM
    
    WindowGroup {
      ZStack {
        UIPilotHost(navigator) { route in
          switch route {
          case is Screen.RootScreen: RootScreen(strongVM: vm)
          case is Screen.LoginScannerScreen: LoginScannerScreen()
          case is Screen.SwitchEventScreen: SwitchEventScreen()
          case is Screen.SettingsScreen: SettingsScreen()
          case is Screen.UpdateApp: UpdateAppScreen()
          case let s as Screen.RegisterScreen: RegisterScreen(createToken: s.createToken)
          case let s as Screen.TableDetailScreen: TableDetailScreen(table: s.table)
          case let s as Screen.OrderScreen: OrderScreen(table: s.table, initialItemId: s.initialItemId)
          case let s as Screen.BillingScreen: BillingScreen(table: s.table)
          default:
            Text("No view defined for \(route.self.description)") // TODO
            Button {
              navigator.pop()
            } label: {
              Text("Back")
            }.onAppear {
              koin.logger(tag: "WaiterRobotApp").e { "No view defined for \(route.self.description)" }
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
        S.app.updateAvailable.title(),
        isPresented: $showUpdateAvailableAlert
      ) {
        Button(S.dialog.cancel(), role: .cancel) {
          showUpdateAvailableAlert = false
        }
        
        Button (S.app.forceUpdate.openStore(value0: "App Store")) {
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
        Text(S.app.updateAvailable.message())
      }
      .onAppear {
        VersionChecker.shared.checkVersion {
          showUpdateAvailableAlert = true
        }
      }
    }
  }
}
