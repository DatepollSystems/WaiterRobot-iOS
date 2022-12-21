import Foundation
import SwiftUI
import shared
import UIPilot

struct LoginScreen: View {
  @EnvironmentObject var navigator: UIPilot<Screen>
  
  @StateObject private var strongVM = ObservableViewModel(vm: koin.loginVM())
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      VStack {
        Spacer()
        
        Image("LogoRounded")
          .resizable()
          .scaledToFit()
          .frame(maxWidth: 250)
          .padding()
        Text(S.login.title())
          .font(.title)
          .padding()
        
        Text(S.login.desc())
          .font(.body)
          .padding()
          .multilineTextAlignment(.center)
        
        Button {
          vm.actual.openScanner()
        } label: {
          Label(S.login.withQrCode(), systemImage: "qrcode.viewfinder")
            .font(.title3)
        }
        .padding()
        
        Spacer()
      }
    }
    .navigationBarHidden(true)
    .onReceive(vm.sideEffect) { effect in
      switch effect {
      case let navEffect as NavigationEffect:
        handleNavigation(navEffect.action, navigator)
      default:
        koin.logger(tag: "LoginScreen").w {
          "No action defined for sideEffect \(effect.self.description)"
        }
      }
    }
  }
}
