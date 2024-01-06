import Foundation
import shared
import SwiftUI

struct RootScreen: View {
    @ObservedObject var strongVM: RootObservableViewModel

    var body: some View {
        unowned let vm = strongVM

        if !vm.state.isLoggedIn {
            LoginScreen()
                .navigationBarHidden(true)
        } else if !vm.state.hasEventSelected {
            SwitchEventScreen()
                .navigationBarHidden(false)
        } else {
            TableListScreen()
                .navigationBarHidden(false)
        }
    }
}
