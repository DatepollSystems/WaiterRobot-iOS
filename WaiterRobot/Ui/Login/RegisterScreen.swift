import shared
import SwiftUI
import UIPilot

struct RegisterScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = RegisterObservableViewModel()

    @State private var name: String = ""
    let createToken: String

    var body: some View {
        ScreenContainer(viewModel.state) {
            VStack {
                Text(localize.register.name.desc())
                    .font(.body)

                TextField(localize.register.name.title(), text: $name)
                    .font(.body)
                    .fixedSize()
                    .padding()

                HStack {
                    Button {
                        viewModel.actual.cancel()
                    } label: {
                        Text(localize.dialog.cancel())
                    }

                    Spacer()

                    Button {
                        viewModel.actual.onRegister(name: name, createToken: createToken)
                    } label: {
                        Text(localize.register.login())
                    }
                }
                .padding()

                Label(localize.register.alreadyRegisteredInfo(), systemImage: "info.circle.fill")
            }
            .padding()
        }
        .navigationBarHidden(true)
        .handleSideEffects(of: viewModel, navigator)
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen(createToken: "")
    }
}
