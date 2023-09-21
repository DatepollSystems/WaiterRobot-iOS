import shared
import SwiftUI
import UIPilot

struct OrderScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @State private var productName: String = ""
    @State private var showProductSearch: Bool

    @StateObject private var strongVM: ObservableViewModel<OrderState, OrderEffect, OrderViewModel>
    private let table: shared.Table

    init(table: shared.Table, initialItemId: KotlinLong?) {
        self.table = table
        _strongVM = StateObject(wrappedValue: ObservableViewModel(vm: koin.orderVM(table: table, initialItemId: initialItemId)))
        showProductSearch = initialItemId == nil ? true : false
    }

    var body: some View {
        unowned let vm = strongVM

        ScreenContainer(vm.state) {
            ZStack {
                VStack {
                    if vm.state.currentOrder.isEmpty {
                        Text(localize.order.addProduct())
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        List {
                            ForEach(vm.state.currentOrder, id: \.product.id) { orderItem in
                                OrderListItem(
                                    name: orderItem.product.name,
                                    amount: orderItem.amount,
                                    note: orderItem.note,
                                    addOne: { vm.actual.addItem(product: orderItem.product, amount: 1) },
                                    removeOne: { vm.actual.addItem(product: orderItem.product, amount: -1) },
                                    removeAll: { vm.actual.removeAllOfProduct(productId: orderItem.product.id) },
                                    onSaveNote: { note in
                                        vm.actual.addItemNote(item: orderItem, note: note)
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
                    vm.actual.sendOrder()
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(vm.state.currentOrder.isEmpty || vm.state.viewState != ViewState.Idle.shared)
            }
        }
        .customBackNavigation(title: localize.dialog.cancel(), icon: "chevron.backward", action: vm.actual.goBack)
        .confirmationDialog(localize.order.notSent.title(), isPresented: Binding.constant(vm.state.showConfirmationDialog), titleVisibility: .visible) {
            Button(localize.dialog.closeAnyway(), role: .destructive, action: vm.actual.abortOrder)
            Button(localize.order.keepOrder(), role: .cancel, action: vm.actual.keepOrder)
        } message: {
            Text(localize.order.notSent.desc())
        }
        .sheet(isPresented: $showProductSearch) {
            ProductSearch(vm: vm)
        }
        .handleSideEffects(of: vm, navigator)
    }
}
