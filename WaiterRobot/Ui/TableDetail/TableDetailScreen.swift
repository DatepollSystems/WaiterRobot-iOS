import shared
import SwiftUI
import UIPilot

struct TableDetailScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel: ObservableViewModel<TableDetailState, TableDetailEffect, TableDetailViewModel>
    private let table: shared.Table

    init(table: shared.Table) {
        self.table = table
        _viewModel = StateObject(wrappedValue: ObservableViewModel(viewModel: koin.tableDetailVM(table: table)))
    }

    var body: some View {
        ScreenContainer(viewModel.state) {
            ZStack {
                List {
                    if viewModel.state.orderedItems.isEmpty {
                        Text(localize.tableDetail.noOrder(value0: table.number.description, value1: table.groupName))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        ForEach(viewModel.state.orderedItems, id: \.id) { item in
                            OrderedItemView(item: item) {
                                viewModel.actual.openOrderScreen(initialItemId: item.id.toKotlinLong())
                            }
                        }
                    }
                }

                EmbeddedFloatingActionButton(icon: "plus") {
                    viewModel.actual.openOrderScreen(initialItemId: nil)
                }
            }
        }
        .refreshable {
            viewModel.actual.loadOrder()
        }
        .navigationTitle(localize.tableDetail.title(value0: table.number.description, value1: table.groupName))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.actual.openBillingScreen()
                } label: {
                    Image(systemName: "creditcard")
                }.disabled(viewModel.state.orderedItems.isEmpty)
            }
        }
        .handleSideEffects(of: viewModel, navigator)
    }
}
