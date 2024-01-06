import shared
import SwiftUI
import UIPilot

struct OrderScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @State private var productName: String = ""
    @State private var showProductSearch: Bool

    @StateObject private var viewModel: OrderObservableViewModel
    private let table: shared.Table

    init(table: shared.Table, initialItemId: KotlinLong?) {
        self.table = table
        _viewModel = StateObject(wrappedValue: OrderObservableViewModel(table: table, initialItemId: initialItemId))
        showProductSearch = initialItemId == nil ? true : false
    }

    var body: some View {
        ScreenContainer(viewModel.state) {
            ZStack {
                VStack {
                    if viewModel.state.currentOrder.isEmpty {
                        Text(localize.order.addProduct())
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        List {
                            ForEach(viewModel.state.currentOrder, id: \.product.id) { orderItem in
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

                EmbeddedFloatingActionButton(icon: "plus") {
                    showProductSearch = true
                }
            }
        }
        .navigationTitle(localize.order.title(value0: table.number.description, value1: table.groupName))
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.actual.sendOrder()
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(viewModel.state.currentOrder.isEmpty || viewModel.state.viewState != ViewState.Idle.shared)
            }
        }
        .customBackNavigation(title: localize.dialog.cancel(), icon: "chevron.backward", action: { viewModel.actual.goBack() })
        .confirmationDialog(localize.order.notSent.title(), isPresented: Binding.constant(viewModel.state.showConfirmationDialog), titleVisibility: .visible) {
            Button(localize.dialog.closeAnyway(), role: .destructive, action: { viewModel.actual.abortOrder() })
            Button(localize.order.keepOrder(), role: .cancel, action: { viewModel.actual.keepOrder() })
        } message: {
            Text(localize.order.notSent.desc())
        }
        .sheet(isPresented: $showProductSearch) {
            ProductSearch(viewModel: viewModel)
        }
        .handleSideEffects(of: viewModel, navigator)
    }
}
