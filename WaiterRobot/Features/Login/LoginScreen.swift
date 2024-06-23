import Foundation
import shared
import SharedUI
import SwiftUI
import UIPilot
import WRCore

struct LoginScreen: View {
    @Namespace private var loginNamespace

    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableLoginViewModel()

    @State private var showGetStartedButton = false
    @State private var showLogin = false

    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.accent)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.accent).withAlphaComponent(0.2)
    }

    var body: some View {
        ZStack {
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
        .animation(.spring, value: showGetStartedButton)
        .animation(.spring, value: showLogin)
    }

    @ViewBuilder
    private func content() -> some View {
        if showLogin {
            loginContent()
        } else {
            getStarted()
        }
    }

    private func getStarted() -> some View {
        VStack {
            Spacer()

            logo()

            Spacer()

            Text("Willkommen bei")
                .textStyle(.h3)

            HStack(spacing: 0) {
                Text("kellner.")
                    .textStyle(.h2, textColor: .title)

                Text("team")
                    .textStyle(.h2, textColor: .palletOrange)
            }

            Spacer()

            if showGetStartedButton {
                Button {
                    showLogin = true
                } label: {
                    Text("Get started")
                        .textStyle(.body, textColor: .white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.primary)
            }
        }
        .padding()
        .task {
            do {
                try await Task.sleep(seconds: 2)
                showGetStartedButton = true
            } catch {}
        }
    }

    private func loginContent() -> some View {
        VStack {
            Spacer()

            Spacer()

            logo()

            Text(localize.login.title())
                .textStyle(.h3)
                .padding()

            Text(localize.login.desc())
                .textStyle(.body)
                .padding()
                .multilineTextAlignment(.center)

            Spacer()

            Button {
                viewModel.actual.openScanner()
            } label: {
                Label(localize.login.withQrCode(), systemImage: "qrcode.viewfinder")
                    .textStyle(.body, textColor: .white)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.primary)
            .padding()
        }
        .withViewModel(viewModel, navigator)
    }

    private func logo() -> some View {
        Image.logoRounded
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 250)
            .padding()
            .matchedGeometryEffect(id: "logo", in: loginNamespace)
    }
}

#Preview {
    PreviewView {
        LoginScreen()
    }
}
