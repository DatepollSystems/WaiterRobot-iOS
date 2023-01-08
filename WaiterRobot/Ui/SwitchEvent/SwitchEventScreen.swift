import SwiftUI
import UIPilot
import shared

struct SwitchEventScreen: View {
  @EnvironmentObject var navigator: UIPilot<Screen>
  
  @StateObject private var strongVM = ObservableViewModel(vm: koin.switchEventVM())
  
  @SwiftUI.State private var selectedEvent: Event? = nil
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      VStack {
        Image(systemName: "person.3")
          .resizable()
          .scaledToFit()
          .frame(maxHeight: 100)
          .padding()
        
        Text(S.switchEvent.desc())
          .multilineTextAlignment(.center)
          .padding()
        
        Divider()
        
        ScrollView {
          if vm.state.events.isEmpty {
            Text(S.switchEvent.noEventFound())
              .multilineTextAlignment(.center)
              .padding()
          } else {
            LazyVStack {
              ForEach(vm.state.events, id: \.id) { event in
                Button {
                  vm.actual.onEventSelected(event: event)
                } label: {
                  Event(event: event)
                    .padding(.horizontal)
                }.foregroundColor(Color("textColor"))
                Divider()
              }
            }
          }
        }
        .refreshable {
          vm.actual.loadEvents()
        }
      }
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
}

struct SwitchEventScreen_Previews: PreviewProvider {
  static var previews: some View {
    SwitchEventScreen()
  }
}
