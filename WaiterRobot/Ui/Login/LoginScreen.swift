import Foundation
import shared
import SwiftUI
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
                Text(localizeString.login.title())
                    .font(.title)
                    .padding()

                Text(localizeString.login.desc())
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)

                Button {
                    vm.actual.openScanner()
                } label: {
                    Label(localizeString.login.withQrCode(), systemImage: "qrcode.viewfinder")
                        .font(.title3)
                }
                .padding()

                Spacer()
            }
        }
        .handleSideEffects(of: vm, navigator)
    }
}
