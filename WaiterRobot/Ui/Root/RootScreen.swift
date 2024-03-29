import Foundation
import shared
import SwiftUI

struct RootScreen: View {
    @ObservedObject var viewModel: ObservableRootViewModel

    var body: some View {
        if !viewModel.state.isLoggedIn {
            LoginScreen()
                .navigationBarHidden(true)
        } else if !viewModel.state.hasEventSelected {
            SwitchEventScreen()
                .navigationBarHidden(false)
        } else {
            TableListScreen()
                .navigationBarHidden(false)
        }
    }
}
