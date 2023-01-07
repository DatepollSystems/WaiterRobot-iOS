import SwiftUI
import shared
import CodeScanner
import UIPilot

struct LoginScannerScreen: View {
  @EnvironmentObject var navigator: UIPilot<Screen>
  
  @StateObject private var strongVM = ObservableViewModel(vm: koin.loginScannerVM())
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      VStack {
        CodeScannerView(
          codeTypes: [.qr],
          simulatedData: "https://lava.kellner.team/ml/signIn?token=sONDq4mMVVAwUY2AvkmBDAfI5DM&purpose=CREATE"
        ) { result in
          switch result {
          case .success(let result):
            vm.actual.onCode(code: result.string)
          case .failure(let error):
            koin.logger(tag: "LoginScanner").e { error.localizedDescription }
          }
        }
        
        Text(S.login.scanner.desc())
          .padding()
          .multilineTextAlignment(.center)
        
        Button {
          vm.actual.goBack()
        } label: {
          Text(S.dialog.cancel())
        }
      }
    }
    .navigationBarHidden(true)
    .onReceive(vm.sideEffect) { effect in
      switch effect {
      case let navEffect as NavigationEffect:
        handleNavigation(navEffect.action, navigator)
      default:
        koin.logger(tag: "LoginScannerScreen").w {
          "No action defined for sideEffect \(effect.self.description)"
        }
      }
    }
  }
}

struct LoginScannerScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScannerScreen()
    }
}