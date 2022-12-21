import SwiftUI
import UIPilot
import shared

@main
struct WaiterRobotApp: App {
  @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
  
  @StateObject private var navigator: UIPilot<Screen> = UIPilot(initial: Screen.RootScreen.shared, debug: true)
  @StateObject private var strongVM = ObservableViewModel(vm: koin.rootVM())
  
  var body: some Scene {
    unowned let vm = strongVM
    
    WindowGroup {
      VStack {
        UIPilotHost(navigator) { route in
          switch route {
          case is Screen.RootScreen: RootScreen(strongVM: vm)
          case is Screen.LoginScannerScreen: LoginScannerScreen()
          case is Screen.SwitchEventScreen: SwitchEventScreen()
          case let s as Screen.RegisterScreen: RegisterScreen(createToken: s.createToken)
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
      .onReceive(vm.sideEffect) { effect in
        switch effect {
        case let navEffect as NavigationEffect:
          handleNavigation(navEffect.action, navigator)
        default:
          koin.logger(tag: "WaiterRobotApp").w { "No action defined for sideEffect \(effect.self.description)"}
        }
      }
      .onOpenURL { url in
        vm.actual.onDeepLink(url: url.absoluteString)
      }
    }
  }
}
