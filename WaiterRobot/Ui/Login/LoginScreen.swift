import Foundation
import shared
import SwiftUI
import UIPilot

struct LoginScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var vm = ObservableViewModel(viewModel: koin.loginVM())

    var body: some View {
        ScreenContainer(vm.state) {
            VStack {
                Spacer()

                Image(.logoRounded)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 250)
                    .padding()
                Text(localize.login.title())
                    .font(.title)
                    .padding()

                Text(localize.login.desc())
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)

                Button {
                    vm.actual.openScanner()
                } label: {
                    Label(localize.login.withQrCode(), systemImage: "qrcode.viewfinder")
                        .font(.title3)
                }
                .padding()

                Spacer()
            }
        }
        .handleSideEffects(of: vm, navigator)
    }
}
