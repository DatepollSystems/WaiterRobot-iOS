import shared
import SwiftUI
import UIPilot

struct SwitchEventScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableSwitchEventViewModel()

    @SwiftUI.State private var selectedEvent: Event?

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
            Image(systemName: "person.3")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 100)
                .padding()

            Text(localize.switchEvent.desc())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()

            Divider()

            ScrollView {
                if viewModel.state.events.isEmpty {
                    Text(localize.switchEvent.noEventFound())
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    LazyVStack {
                        ForEach(viewModel.state.events, id: \.id) { event in
                            Button {
                                viewModel.actual.onEventSelected(event: event)
                            } label: {
                                Event(event: event)
                                    .padding(.horizontal)
                            }.foregroundColor(.blackWhite)
                            Divider()
                        }
                    }
                }
            }
            .refreshable {
                viewModel.actual.loadEvents()
            }
        }
        .handleSideEffects(of: viewModel, navigator)
    }
}

#Preview {
    SwitchEventScreen()
}
