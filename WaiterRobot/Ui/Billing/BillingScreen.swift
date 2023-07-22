import Foundation
import shared
import SwiftUI
import UIPilot

struct BillingScreen: View {
	@EnvironmentObject var navigator: UIPilot<Screen>

	@State private var showPayDialog: Bool = false
	@StateObject private var strongVM: ObservableViewModel<BillingState, BillingEffect, BillingViewModel>
	private let table: shared.Table

	init(table: shared.Table) {
		self.table = table
		_strongVM = StateObject(wrappedValue: ObservableViewModel(vm: koin.billingVM(table: table)))
	}

	var body: some View {
		unowned let vm = strongVM

		ScreenContainer(vm.state) {
			VStack {
				List {
					if vm.state.billItems.isEmpty {
						Text(L.billing.noOpenBill(value0: table.number.description, value1: table.groupName))
							.multilineTextAlignment(.center)
							.frame(maxWidth: .infinity)
							.padding()
					} else {
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
				}
				.refreshable {
					vm.actual.loadBill()
				}

				HStack {
					Text("\(L.billing.total()):")
					Spacer()
					Text("\(vm.state.priceSum)")
				}
				.font(.title2)
				.padding()
				.overlay(alignment: .bottom) {
					Button {
						showPayDialog = true
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
		.navigationTitle(L.billing.title(value0: table.number.description, value1: table.groupName))
		.navigationBarTitleDisplayMode(.inline)
		.customBackNavigation(title: L.dialog.cancel(), icon: nil, action: vm.actual.goBack) // TODO:
		.confirmationDialog(L.billing.notSent.title(), isPresented: Binding.constant(vm.state.showConfirmationDialog), titleVisibility: .visible) {
			Button(L.dialog.closeAnyway(), role: .destructive, action: vm.actual.abortBill)
			Button(L.dialog.cancel(), role: .cancel, action: vm.actual.keepBill)
		} message: {
			Text(L.billing.notSent.desc())
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
		.sheet(isPresented: $showPayDialog) {
			PayDialog(vm: vm)
		}
		.handleSideEffects(of: vm, navigator)
	}
}
