import shared
import SwiftUI
import UIPilot

struct OrderScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @State private var productName: String = ""
    @State private var showProductSearch: Bool
    @State private var showAbortOrderConfirmationDialog = false

    @StateObject private var viewModel: ObservableOrderViewModel
    private let table: shared.Table

    init(table: shared.Table, initialItemId: KotlinLong?) {
        self.table = table
        _viewModel = StateObject(wrappedValue: ObservableOrderViewModel(table: table, initialItemId: initialItemId))
        showProductSearch = initialItemId == nil ? true : false

        UIToolbar.appearance().barTintColor = UIColor.systemBackground // Background color
        UIToolbar.appearance().tintColor = UIColor.blue // Tint color of buttonss
    }

    var body: some View {
        VStack {
            switch onEnum(of: viewModel.state.currentOrder) {
            case .loading:
                ProgressView()

            case let .error(error):
                Text(error.userMessage)

            case let .success(resource):
                if let data = resource.data {
                    currentOder(data)
                }
            }
        }
        .navigationTitle(localize.order.title(value0: table.number.description, value1: table.groupName))
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .confirmationDialog(
            localize.order.notSent.title(),
            isPresented: $showAbortOrderConfirmationDialog,
            titleVisibility: .visible
        ) {
            Button(localize.dialog.closeAnyway(), role: .destructive) {
                viewModel.actual.abortOrder()
            }
        } message: {
            Text(localize.order.notSent.desc())
        }
        .sheet(isPresented: $showProductSearch) {
            ProductSearch(viewModel: viewModel)
        }
        .handleSideEffects(of: viewModel, navigator)
    }

    @ViewBuilder
    private func currentOder(
        _ currentOrderArray: KotlinArray<OrderItem>
    ) -> some View {
        let currentOrder = Array(currentOrderArray)

        VStack(spacing: 0) {
            if currentOrder.isEmpty {
                Spacer()

                Text(localize.order.addProduct())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()

                Spacer()
            } else {
                List {
                    ForEach(currentOrder, id: \.product.id) { orderItem in
                        OrderListItem(
                            name: orderItem.product.name,
                            amount: orderItem.amount,
                            note: orderItem.note,
                            addOne: { viewModel.actual.addItem(product: orderItem.product, amount: 1) },
                            removeOne: { viewModel.actual.addItem(product: orderItem.product, amount: -1) },
                            removeAll: { viewModel.actual.removeAllOfProduct(productId: orderItem.product.id) },
                            onSaveNote: { note in
                                viewModel.actual.addItemNote(item: orderItem, note: note)
                            }
                        )
                    }
                }
            }
        }
        .wrBottomBar {
            Button {
                viewModel.actual.sendOrder()
            } label: {
                Image(systemName: "paperplane.fill")
                    .imageScale(.small)
                    .padding(10)
            }
            .buttonStyle(.wrBorderedProminent)
            .disabled(currentOrder.isEmpty)

            Spacer()

            Button {
                showProductSearch = true
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding()
            }
            .buttonStyle(.wrBorderedProminent)
        }
        .customBackNavigation(title: localize.dialog.cancel(), icon: "chevron.backward") {
            if currentOrder.isEmpty {
                viewModel.actual.abortOrder()
            } else {
                showAbortOrderConfirmationDialog = true
            }
        }
    }
}
