import CodeScanner
import shared
import SwiftUI
import UIPilot

struct LoginScannerScreen: View {
	@EnvironmentObject var navigator: UIPilot<Screen>

	@StateObject private var strongVM = ObservableViewModel(vm: koin.loginScannerVM())

	var body: some View {
		unowned let vm = strongVM

		ScreenContainer(vm.state) {
			VStack {
				CodeScannerView(
					codeTypes: [.qr],
					simulatedData: "https://my.kellner.team/ml/signIn?token=gj8TeJ4eQ0oRhD5yw8THx5OFhjQ&purpose=SIGN_IN"
				) { result in
					switch result {
					case let .success(result):
						vm.actual.onCode(code: result.string)
					case let .failure(error):
						koin.logger(tag: "LoginScanner").e { error.localizedDescription }
					}
				}

				Text(S.login.scanner.desc())
					.padding()
					.multilineTextAlignment(.center)

				Button {
					vm.actual.goBack()
				} label: {
					Text(S.dialog.cancel())
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
