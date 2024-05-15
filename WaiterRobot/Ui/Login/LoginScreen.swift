import Foundation
import shared
import SwiftUI
import UIPilot

struct LoginScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableLoginViewModel()

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
                viewModel.actual.openScanner()
            } label: {
                Label(localize.login.withQrCode(), systemImage: "qrcode.viewfinder")
                    .font(.title3)
            }
            .padding()

            Spacer()
        }
        .handleSideEffects(of: viewModel, navigator)
    }
}
