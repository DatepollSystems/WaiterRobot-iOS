import SwiftUI
import shared
import UIPilot

struct TableDetailScreen: View {
  
  @EnvironmentObject var navigator: UIPilot<Screen>
  
  @StateObject private var strongVM: ObservableViewModel<TableDetailState, TableDetailEffect, TableDetailViewModel>
  private let table: shared.Table
  
  init(table: shared.Table) {
    self.table = table
    self._strongVM = StateObject(wrappedValue: ObservableViewModel(vm: koin.tableDetailVM(table: table)))
  }
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      if vm.state.orderedItems.isEmpty {
        Text(S.tableDetail.noOrder(value0: table.number.description))
      } else {
        List {
          ForEach(vm.state.orderedItems, id: \.id) { item in
            OrderedItemView(item: item) {
              vm.actual.openOrderScreen(initialItemId: item.id.toKotlinLong())
            }
          }
        }
      }
    }
    .navigationTitle(S.tableDetail.title(value0: table.number.description))
    .floatingActionButton(icon: "plus") {
      vm.actual.openOrderScreen(initialItemId: nil)
    }
    .onReceive(vm.sideEffect) { effect in
      switch effect {
      case let navEffect as NavigationEffect:
        handleNavigation(navEffect.action, navigator)
      default:
        koin.logger(tag: "TableDetailScreen").w {
          "No action defined for sideEffect \(effect.self.description)"
        }
      }
    }
  }
}
