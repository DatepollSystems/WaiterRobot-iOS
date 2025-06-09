import shared
import SwiftUI
import UIPilot
import WRCore

struct SwitchEventScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableSwitchEventViewModel()

    @State private var selectedEvent: Event?

    var body: some View {
        VStack {
            Image(systemName: "person.3")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 100)
                .padding()

            Text(localize.switchEvent_desc())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()

            Divider()

            content(viewModel.state.events)
                .refreshable {
                    try? await viewModel.actual.loadEvents().join()
                }

        }.withViewModel(viewModel, navigator)
    }

    private func content(_ eventResource: shared.Resource<KotlinArray<shared.Event>>) -> some View {
        ScrollView {
            let resource = onEnum(of: eventResource)

            if case let .error(error) = resource {
                ErrorBar(message: error.userMessage, retryAction: { viewModel.actual.loadEvents() })
            }
            if let events = Array(resource.data) {
                if events.isEmpty {
                    Text(localize.switchEvent_noEventFound())
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    LazyVStack {
                        ForEach(events, id: \.id) { event in
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
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    SwitchEventScreen()
}
