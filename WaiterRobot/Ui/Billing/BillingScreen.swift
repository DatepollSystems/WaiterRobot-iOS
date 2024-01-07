import Foundation
import shared
import SwiftUI
import UIPilot

struct BillingScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @State private var showPayDialog: Bool = false
    @StateObject private var viewModel: ObservableBillingViewModel
    private let table: shared.Table

    init(table: shared.Table) {
        self.table = table
        _viewModel = StateObject(wrappedValue: ObservableBillingViewModel(table: table))
    }

    var body: some View {
        ScreenContainer(viewModel.state) {
            VStack {
                List {
                    if viewModel.state.billItems.isEmpty {
                        Text(localize.billing.noOpenBill(value0: table.number.description, value1: table.groupName))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Section {
                            ForEach(viewModel.state.billItems, id: \.self) { item in
                                BillListItem(
                                    item: item,
                                    addOne: {
                                        viewModel.actual.addItem(id: item.productId, amount: 1)
                                    },
                                    addAll: {
                                        viewModel.actual.addItem(id: item.productId, amount: item.ordered - item.selectedForBill)
                                    },
                                    removeOne: {
                                        viewModel.actual.addItem(id: item.productId, amount: -1)
                                    },
                                    removeAll: {
                                        viewModel.actual.addItem(id: item.productId, amount: -item.selectedForBill)
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
                    viewModel.actual.loadBill()
                }

                HStack {
                    Text("\(localize.billing.total()):")
                    Spacer()
                    Text("\(viewModel.state.priceSum)")
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
                    .disabled(viewModel.state.viewState != ViewState.Idle.shared || !viewModel.state.hasSelectedItems)
                }
            }
        }
        .navigationTitle(localize.billing.title(value0: table.number.description, value1: table.groupName))
        .navigationBarTitleDisplayMode(.inline)
        .customBackNavigation(title: localize.dialog.cancel(), icon: nil, action: { viewModel.actual.goBack() }) // TODO:
        .confirmationDialog(localize.billing.notSent.title(), isPresented: Binding.constant(viewModel.state.showConfirmationDialog), titleVisibility: .visible) {
            Button(localize.dialog.closeAnyway(), role: .destructive, action: { viewModel.actual.abortBill() })
            Button(localize.dialog.cancel(), role: .cancel, action: { viewModel.actual.keepBill() })
        } message: {
            Text(localize.billing.notSent.desc())
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.actual.selectAll()
                } label: {
                    Image(systemName: "checkmark")
                }

                Button {
                    viewModel.actual.unselectAll()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .sheet(isPresented: $showPayDialog) {
            PayDialog(viewModel: viewModel)
        }
        .handleSideEffects(of: viewModel, navigator)
    }
}
