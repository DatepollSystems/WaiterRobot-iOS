import CodeScanner
import shared
import SwiftUI
import UIPilot

struct LoginScannerScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var vm = LoginScannerObservableViewModel()

    var body: some View {
        ScreenContainer(vm.state) {
            VStack {
                CodeScannerView(
                    codeTypes: [.qr],
                    simulatedData: "https://lava.kellner.team/ml/signIn?token=w7wF6pgYA6Ssm3VBH-rSFL6if70&purpose=SIGN_IN"
                ) { result in
                    switch result {
                    case let .success(result):
                        vm.actual.onCode(code: result.string)
                    case let .failure(error):
                        koin.logger(tag: "LoginScanner").e { error.localizedDescription }
                    }
                }

                Text(localize.login.scanner.desc())
                    .padding()
                    .multilineTextAlignment(.center)

                Button {
                    vm.actual.goBack()
                } label: {
                    Text(localize.dialog.cancel())
                }
            }
        }
        .handleSideEffects(of: vm, navigator)
    }
}

struct LoginScannerScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScannerScreen()
    }
}
