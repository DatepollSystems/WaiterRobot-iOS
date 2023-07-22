import shared
import SwiftUI
import UIPilot

struct TableDetailScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var strongVM: ObservableViewModel<TableDetailState, TableDetailEffect, TableDetailViewModel>
    private let table: shared.Table

    init(table: shared.Table) {
        self.table = table
        _strongVM = StateObject(wrappedValue: ObservableViewModel(vm: koin.tableDetailVM(table: table)))
    }

    var body: some View {
        unowned let vm = strongVM

        ScreenContainer(vm.state) {
            List {
                if vm.state.orderedItems.isEmpty {
                    Text(localize.tableDetail.noOrder(value0: table.number.description, value1: table.groupName))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    ForEach(vm.state.orderedItems, id: \.id) { item in
                        OrderedItemView(item: item) {
                            vm.actual.openOrderScreen(initialItemId: item.id.toKotlinLong())
                        }
                    }
                }
            }
        }
        .refreshable {
            vm.actual.loadOrder()
        }
        .navigationTitle(localize.tableDetail.title(value0: table.number.description, value1: table.groupName))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.actual.openBillingScreen()
                } label: {
                    Image(systemName: "creditcard")
                }.disabled(vm.state.orderedItems.isEmpty)
            }

            ToolbarItem(placement: .bottomBar) {
                Button {
                    vm.actual.openOrderScreen(initialItemId: nil)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .handleSideEffects(of: vm, navigator)
    }
}
