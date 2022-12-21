import SwiftUI
import UIPilot
import shared

struct RegisterScreen: View {
  @EnvironmentObject var navigator: UIPilot<Screen>
  
  @StateObject private var strongVM = ObservableViewModel(vm: koin.registerVM())
  
  @State private var name: String = ""
  let createToken: String
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      VStack {
        Text(S.register_.name.desc())
          .font(.body)
        
        TextField(S.register_.name.title(), text: $name)
          .font(.body)
          .fixedSize()
          .padding()
        
        HStack {
          Button {
            vm.actual.cancel()
          } label: {
            Text(S.dialog.cancel())
          }
          
          Spacer()
          
          Button {
            vm.actual.onRegister(name: name, createToken: createToken)
          } label: {
            Text(S.register_.login())
          }
        }
        .padding()
        
        Label(S.register_.alreadyRegisteredInfo(), systemImage: "info.circle.fill")
      }
      .padding()
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

struct RegisterScreen_Previews: PreviewProvider {
  static var previews: some View {
    RegisterScreen(createToken: "")
  }
}
