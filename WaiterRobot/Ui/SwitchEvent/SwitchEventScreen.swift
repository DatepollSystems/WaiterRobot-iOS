import shared
import SwiftUI
import UIPilot

struct SwitchEventScreen: View {
	@EnvironmentObject var navigator: UIPilot<Screen>

	@StateObject private var strongVM = ObservableViewModel(vm: koin.switchEventVM())

	@SwiftUI.State private var selectedEvent: Event? = nil

	var body: some View {
		unowned let vm = strongVM

		ScreenContainer(vm.state) {
			VStack {
				Image(systemName: "person.3")
					.resizable()
					.scaledToFit()
					.frame(maxHeight: 100)
					.padding()

				Text(S.switchEvent.desc())
					.multilineTextAlignment(.center)
					.frame(maxWidth: .infinity)
					.padding()

				Divider()

				ScrollView {
					if vm.state.events.isEmpty {
						Text(S.switchEvent.noEventFound())
							.multilineTextAlignment(.center)
							.frame(maxWidth: .infinity)
							.padding()
					} else {
						LazyVStack {
							ForEach(vm.state.events, id: \.id) { event in
								Button {
									vm.actual.onEventSelected(event: event)
								} label: {
									Event(event: event)
										.padding(.horizontal)
								}.foregroundColor(Color("textColor"))
								Divider()
							}
						}
					}
				}
				.refreshable {
					vm.actual.loadEvents()
				}
			}
			.handleSideEffects(of: vm, navigator)
		}
	}
}

struct SwitchEventScreen_Previews: PreviewProvider {
	static var previews: some View {
		SwitchEventScreen()
	}
}
