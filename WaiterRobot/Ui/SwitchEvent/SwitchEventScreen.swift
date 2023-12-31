import shared
import SwiftUI
import UIPilot

struct SwitchEventScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableViewModel(viewModel: koin.switchEventVM())

    @SwiftUI.State private var selectedEvent: Event?

    var body: some View {
        ScreenContainer(viewModel.state) {
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
}

struct SwitchEventScreen_Previews: PreviewProvider {
    static var previews: some View {
        SwitchEventScreen()
    }
}
