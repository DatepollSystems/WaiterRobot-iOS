import Foundation
import shared
import SharedUI
import SwiftUI
import UIPilot
import WRCore

struct LoginScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableLoginViewModel()
    @State private var showLinkInput = false
    @State private var debugLoginLink = ""

    var body: some View {
        switch onEnum(of: viewModel.state.viewState) {
        case .loading:
            ProgressView()
        case .idle:
            content()
        case let .error(error):
            content()
                .alert(isPresented: Binding.constant(true)) {
                    Alert(error.dialog)
                }
        }
    }

    private func content() -> some View {
        VStack {
            Spacer()

            Image.logoRounded
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 250)
                .padding()
                .onLongPressGesture {
                    showLinkInput = true
                }
            Text(localize.login_title())
                .font(.title)
                .padding()

            Text(localize.login_desc())
                .font(.body)
                .padding()
                .multilineTextAlignment(.center)

            Button {
                viewModel.actual.openScanner()
            } label: {
                Label(localize.login_withQrCode(), systemImage: "qrcode.viewfinder")
                    .font(.title3)
            }
            .padding()

            Spacer()
        }
        .alert(localize.login_title(), isPresented: $showLinkInput) {
            TextField(localize.login_scanner_debugDialog_inputLabel(), text: $debugLoginLink)
            Button(localize.dialog_cancel(), role: .cancel) {
                showLinkInput = false
            }
            Button(localize.login_title()) {
                viewModel.actual.onDebugLogin(link: debugLoginLink)
            }
        }
        .withViewModel(viewModel, navigator)
    }
}

#Preview {
    PreviewView {
        LoginScreen()
    }
}
