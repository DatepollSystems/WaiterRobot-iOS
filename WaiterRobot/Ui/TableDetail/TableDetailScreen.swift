import shared
import SwiftUI
import UIPilot

struct TableDetailScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var vm: TableDetailObservableViewModel
    private let table: shared.Table

    init(table: shared.Table) {
        self.table = table
        _vm = StateObject(wrappedValue: TableDetailObservableViewModel(table: table))
    }

    var body: some View {
        let resource = onEnum(of: vm.state.orderedItemsResource)
        let orderedItems = vm.state.orderedItemsResource.data as? [OrderedItem]

        // TODO: add refreshing and loading indicator (also check android)
        ZStack {
            VStack {
                if case let .error(value) = resource {
                    Text(value.exception.getLocalizedUserMessage())
                }
                if orderedItems?.isEmpty == true {
                    Text(localize.tableDetail.noOrder(value0: table.number.description, value1: table.groupName))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else if let orderedItems {
                    List {
                        ForEach(orderedItems, id: \.id) { item in
                            OrderedItemView(item: item) {
                                vm.actual.openOrderScreen(initialItemId: item.id.toKotlinLong())
                            }
                        }
                    }
                }
            }

            EmbeddedFloatingActionButton(icon: "plus") {
                vm.actual.openOrderScreen(initialItemId: nil)
            }
        }
        .navigationTitle(localize.tableDetail.title(value0: table.number.description, value1: table.groupName))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.actual.openBillingScreen()
                } label: {
                    Image(systemName: "creditcard")
                }.disabled(orderedItems?.isEmpty != false)
            }
        }
        .handleSideEffects(of: vm, navigator)
    }
}
