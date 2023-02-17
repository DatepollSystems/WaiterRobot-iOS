import SwiftUI
import UIPilot
import shared

struct OrderScreen: View {
  @EnvironmentObject var navigator: UIPilot<Screen>
  
  @State private var productName: String = ""
  @State private var showProductSearch: Bool
  
  @StateObject private var strongVM: ObservableViewModel<OrderState, OrderEffect, OrderViewModel>
  private let table: shared.Table
  
  init(table: shared.Table, initialItemId: KotlinLong?) {
    self.table = table
    self._strongVM = StateObject(wrappedValue: ObservableViewModel(vm: koin.orderVM(table: table, initialItemId: initialItemId)))
    self.showProductSearch = initialItemId == nil ? true : false
  }
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      if(vm.state.currentOrder.isEmpty) {
        Text(S.order.addProduct())
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
    .navigationTitle(S.order.title(value0: table.number.description))
    .navigationBarTitleDisplayMode(.inline)
    .floatingActionButton(icon: "plus") {
      showProductSearch = true
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          vm.actual.sendOrder()
        } label: {
          Image(systemName: "paperplane.fill")
        }.disabled(vm.state.currentOrder.isEmpty || vm.state.viewState != ViewState.Idle.shared)
      }
    }
    .customBackNavigation(title: S.dialog.cancel(), icon: nil, action: vm.actual.goBack)
    .confirmationDialog(S.order.notSent.title(), isPresented: Binding.constant(vm.state.showConfirmationDialog), titleVisibility: .visible) {
      Button(S.dialog.closeAnyway(), role: .destructive, action: vm.actual.abortOrder)
      Button(S.order.keepOrder(), role: .cancel, action: vm.actual.keepOrder)
    } message: {
      Text(S.order.notSent.desc())
    }
    .sheet(isPresented: $showProductSearch) {
      ProductSearch(vm: vm)
    }
    .onReceive(vm.sideEffect) { effect in
      switch effect {
      case let navEffect as NavigationEffect:
        handleNavigation(navEffect.action, navigator)
      default:
        koin.logger(tag: "OrderScreen").w {
          "No action defined for sideEffect \(effect.self.description)"
        }
      }
    }
  }
}
