import shared
import SwiftUI
import UIPilot

struct TableDetailScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel: ObservableTableDetailViewModel
    private let table: shared.Table

    init(table: shared.Table) {
        self.table = table
        _viewModel = StateObject(wrappedValue: ObservableTableDetailViewModel(table: table))
    }

    var body: some View {
        let resource = onEnum(of: viewModel.state.orderedItemsResource)
        let orderedItems = viewModel.state.orderedItemsResource.data as? [OrderedItem]

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
                                viewModel.actual.openOrderScreen(initialItemId: item.id.toKotlinLong())
                            }
                        }
                    }
                }
            }

            EmbeddedFloatingActionButton(icon: "plus") {
                viewModel.actual.openOrderScreen(initialItemId: nil)
            }
        }
        .navigationTitle(localize.tableDetail.title(value0: table.number.description, value1: table.groupName))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.actual.openBillingScreen()
                } label: {
                    Image(systemName: "creditcard")
                }.disabled(orderedItems?.isEmpty != false)
            }
        }
        .handleSideEffects(of: viewModel, navigator)
    }
}
