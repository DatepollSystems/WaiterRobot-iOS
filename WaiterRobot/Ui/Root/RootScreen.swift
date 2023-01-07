import Foundation
import shared
import SwiftUI

struct RootScreen: View {
  
  @ObservedObject var strongVM: ObservableViewModel<RootState, RootEffect, RootViewModel>
  
  var body: some View {
    unowned let vm = strongVM
    
    if (!vm.state.isLoggedIn) {
      LoginScreen()
    } else if(!vm.state.hasEventSelected) {
      SwitchEventScreen()
    } else {
      TableListScreen()
    }
  }
}
