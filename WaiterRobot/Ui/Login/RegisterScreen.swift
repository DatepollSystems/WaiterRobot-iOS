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
                Text(localizeString.register_.name.desc())
                    .font(.body)

                TextField(localizeString.register_.name.title(), text: $name)
                    .font(.body)
                    .fixedSize()
                    .padding()

                HStack {
                    Button {
                        vm.actual.cancel()
                    } label: {
                        Text(localizeString.dialog.cancel())
                    }

                    Spacer()

                    Button {
                        vm.actual.onRegister(name: name, createToken: createToken)
                    } label: {
                        Text(localizeString.register_.login())
                    }
                }
                .padding()

                Label(localizeString.register_.alreadyRegisteredInfo(), systemImage: "info.circle.fill")
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
