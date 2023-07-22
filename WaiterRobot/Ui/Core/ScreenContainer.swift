import shared
import SwiftUI

struct ScreenContainer<Content: View>: View {
	private let content: () -> Content
	private let state: ViewModelState

	init(_ state: ViewModelState, @ViewBuilder content: @escaping () -> Content) {
		self.content = content
		self.state = state
	}

	var body: some View {
		switch state.viewState {
		case is ViewState.Loading:
			ProgressView()
				.scaleEffect(2)
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
			fatalError("Unexpected ViewState: \(state.viewState.description)")
		}
	}
}
