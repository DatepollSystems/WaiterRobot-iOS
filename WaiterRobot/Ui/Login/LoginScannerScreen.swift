import CodeScanner
import shared
import SwiftUI
import UIPilot

struct LoginScannerScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableLoginScannerViewModel()

    private let simulatedData = "https://lava.kellner.team/ml/signIn?token=w7wF6pgYA6Ssm3VBH-rSFL6if70&purpose=SIGN_IN"

    var body: some View {
        switch viewModel.state.viewState {
        case is ViewState.Loading:
            ProgressView()
        case is ViewState.Idle:
            content()
        case let error as ViewState.Error:
            content()
                .alert(isPresented: Binding.constant(true)) {
                    Alert(
                        title: Text(error.title),
                        message: Text(error.message),
                        dismissButton: .cancel(Text("OK"), action: error.onDismiss)
                    )
                }
        default:
            fatalError("Unexpected ViewState: \(viewModel.state.viewState.description)")
        }
    }

    private func content() -> some View {
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
        .handleSideEffects(of: viewModel, navigator)
    }
}

#Preview {
    PreviewView {
        LoginScannerScreen()
    }
}
