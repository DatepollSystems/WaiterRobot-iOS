import shared
import SwiftUI
import UIPilot

struct TableDetailScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel: ObservableTableDetailViewModel
    private let table: shared.Table

    init(table: shared.Table) {
        self.table = table
        _viewModel = StateObject(
            wrappedValue: ObservableTableDetailViewModel(table: table)
        )
    }

    var body: some View {
        content()
            .navigationTitle(localize.tableDetail.title(value0: table.number.description, value1: table.groupName))
            .handleSideEffects(of: viewModel, navigator)
    }

    private func content() -> some View {
        // TODO: add refreshing and loading indicator (also check android)
        ZStack {
            tableDetails()

            EmbeddedFloatingActionButton(icon: "plus") {
                viewModel.actual.openOrderScreen(initialItemId: nil)
            }
        }
    }

    func tableDetails() -> some View {
        VStack {
            switch onEnum(of: viewModel.state.orderedItemsResource) {
            case let .loading(resource):
                ProgressView()

            case let .error(error):
                tableDetailsError(error)

            case let .success(resource):
                // TODO: we need KotlinArray here in shared
                if let orderedItems = resource.data as? [OrderedItem] {
                    VStack {
                        if orderedItems.isEmpty {
                            Text(localize.tableDetail.noOrder(value0: table.number.description, value1: table.groupName))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            List {
                                ForEach(orderedItems, id: \.id) { item in
                                    OrderedItemView(item: item) {
                                        viewModel.actual.openOrderScreen(initialItemId: item.id.toKotlinLong())
                                    }
                                }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewModel.actual.openBillingScreen()
                            } label: {
                                Image(systemName: "creditcard")
                            }
                            .disabled(orderedItems.isEmpty)
                        }
                    }
                } else {
                    Text("Something went wrong")
                }
            }
        }
    }

    func tableDetailsError(_ error: ResourceError<NSArray>) -> some View {
        Text(error.userMessage)
    }
}
