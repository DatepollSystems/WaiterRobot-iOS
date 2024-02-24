import CodeScanner
import shared
import SwiftUI
import UIPilot

struct LoginScannerScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableLoginScannerViewModel()

    private let simulatedData = "https://lava.kellner.team/ml/signIn?purpose=SIGN_IN&token=xWEP33DuYhJzUvQ6clywKPCM_Oa5NymihpJk4-_EGHV3D_f10YSKL_2hOYV3"

    var body: some View {
        ScreenContainer(viewModel.state) {
            VStack {
                CodeScannerView(
                    codeTypes: [.qr],
                    simulatedData: simulatedData
                ) { result in
                    switch result {
                    case let .success(result):
                        viewModel.actual.onCode(code: result.string)
                    case let .failure(error):
                        koin.logger(tag: "LoginScanner").e { error.localizedDescription }
                    }
                }

                Text(localize.login.scanner.desc())
                    .padding()
                    .multilineTextAlignment(.center)

                Button {
                    viewModel.actual.goBack()
                } label: {
                    Text(localize.dialog.cancel())
                }
            }
        }
        .handleSideEffects(of: viewModel, navigator)
    }
}

#Preview {
    PreviewView {
        LoginScannerScreen()
    }
}
