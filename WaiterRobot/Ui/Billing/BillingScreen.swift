import Foundation
import SwiftUI
import shared
import UIPilot

struct BillingScreen: View {
  @EnvironmentObject var navigator: UIPilot<Screen>
  
  @State private var showPayDialog: Bool = false
  @StateObject private var strongVM: ObservableViewModel<BillingState, BillingEffect, BillingViewModel>
  private let table: shared.Table
  
  init(table: shared.Table) {
    self.table = table
    self._strongVM = StateObject(wrappedValue: ObservableViewModel(vm: koin.billingVM(table: table)))
  }
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      VStack {
        if vm.state.billItems.isEmpty {
          Text(S.billing.noOpenBill(value0: table.number.description))
            .multilineTextAlignment(.center)
            .padding()
        } else {
          List {
            Section {
              ForEach(vm.state.billItems, id: \.self) { item in
                BillListItem(
                  item: item,
                  addOne: {
                    vm.actual.addItem(id: item.productId, amount: 1)
                  },
                  addAll: {
                    vm.actual.addItem(id: item.productId, amount: item.ordered - item.selectedForBill)
                  },
                  removeOne: {
                    vm.actual.addItem(id: item.productId, amount: -1)
                  },
                  removeAll: {
                    vm.actual.addItem(id: item.productId, amount: -item.selectedForBill)
                  }
                )
              }
            } header: {
              HStack {
                Text("Ordered")
                Spacer()
                Text("Selected")
              }
            }
          }
          
          HStack {
            Text("\(S.billing.total()):")
            Spacer()
            Text("\(vm.state.priceSum)")
          }
          .font(.title2)
          .padding()
          .overlay(alignment: .bottom) {
            Button {
              vm.actual.paySelection()
            } label: {
              Image(systemName: "dollarsign")
                .font(.system(.title))
                .padding()
                .tint(.white)
            }
            .background(.blue)
            .mask(Circle())
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            .disabled(vm.state.viewState != ViewState.Idle.shared || !vm.state.hasSelectedItems)
          }
        }
      }
    }
    .navigationTitle(S.billing.title(value0: table.number.description))
    .navigationBarTitleDisplayMode(.inline)
    .customBackNavigation(title: S.dialog.cancel(), icon: nil, action: vm.actual.goBack) // TODO
    .confirmationDialog(S.billing.notSent.title(), isPresented: Binding.constant(vm.state.showConfirmationDialog), titleVisibility: .visible) {
      Button(S.dialog.closeAnyway(), role: .destructive, action: vm.actual.abortBill)
      Button(S.dialog.cancel(), role: .cancel, action: vm.actual.keepBill)
    } message: {
      Text(S.billing.notSent.desc())
    }
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button {
          vm.actual.selectAll()
        } label: {
          Image(systemName: "checkmark")
        }
        
        Button {
          vm.actual.unselectAll()
        } label: {
          Image(systemName: "xmark")
        }
      }
    }
    .onReceive(vm.sideEffect) { effect in
      switch effect {
      case let navEffect as NavigationEffect:
        handleNavigation(navEffect.action, navigator)
      default:
        koin.logger(tag: "BillingScreen").w {
          "No action defined for sideEffect \(effect.self.description)"
        }
      }
    }
  }
}
