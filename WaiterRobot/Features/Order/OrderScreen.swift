import shared
import SwiftUI
import UIPilot
import WRCore

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
        UIToolbar.appearance().tintColor = UIColor.blue // Tint color of buttons
    }

    var body: some View {
        ViewStateOverlayView(state: viewModel.state.orderingState) {
            currentOder(Array(viewModel.state.currentOrder))
        }
        .navigationTitle(localize.order_title(table.groupName, table.number.description))
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .confirmationDialog(
            localize.order_notSent_title(),
            isPresented: $showAbortOrderConfirmationDialog,
            titleVisibility: .visible
        ) {
            Button(localize.dialog_closeAnyway(), role: .destructive) {
                viewModel.actual.abortOrder()
            }
        } message: {
            Text(localize.order_notSent_desc())
        }
        .sheet(isPresented: $showProductSearch) {
            ProductSearch(
                addItem: { viewModel.actual.addItem(product: $0, amount: $1) }
            )
        }
        .animation(.default, value: viewModel.state.currentOrder)
        .withViewModel(viewModel, navigator)
    }

    @ViewBuilder
    private func currentOder(
        _ currentOrder: [OrderItem]
    ) -> some View {
        VStack(spacing: 0) {
            if currentOrder.isEmpty {
                Spacer()

                Text(localize.order_product_add())
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
            .buttonStyle(.primary)
            .disabled(currentOrder.isEmpty)

            Spacer()

            Button {
                showProductSearch = true
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding()
            }
            .buttonStyle(.primary)
        }
        .customBackNavigation(title: localize.dialog_cancel(), icon: "chevron.backward") {
            if currentOrder.isEmpty {
                viewModel.actual.abortOrder()
            } else {
                showAbortOrderConfirmationDialog = true
            }
        }
    }
}
