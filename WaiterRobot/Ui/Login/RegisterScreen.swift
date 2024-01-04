import shared
import SwiftUI
import UIPilot

struct RegisterScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var strongVM = ObservableViewModel(vm: koin.registerVM())

    @State private var name: String = ""
    let createToken: String

    var body: some View {
        unowned let vm = strongVM

        ScreenContainer(vm.state) {
            VStack {
                Text(localize.register.name.desc())
                    .font(.body)

                TextField(localize.register.name.title(), text: $name)
                    .font(.body)
                    .fixedSize()
                    .padding()

                HStack {
                    Button {
                        vm.actual.cancel()
                    } label: {
                        Text(localize.dialog.cancel())
                    }

                    Spacer()

                    Button {
                        vm.actual.onRegister(name: name, createToken: createToken)
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
        .handleSideEffects(of: vm, navigator)
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen(createToken: "")
    }
}
