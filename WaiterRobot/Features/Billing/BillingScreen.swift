import Foundation
import shared
import SwiftUI
import UIPilot
import WRCore

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
        BillingScreenView(
            table: table,
            state: viewModel.state,
            abortBill: { viewModel.actual.abortBill() },
            selectAll: { viewModel.actual.selectAll() },
            unselectAll: { viewModel.actual.unselectAll() },
            addItem: { viewModel.actual.addItem(baseProductId: $0, amount: $1) },
            paySelection: { viewModel.actual.paySelection(paymentSheetShown: $0) }
        )
        // TODO: make only half screen when ios 15 is dropped
        .sheet(isPresented: $showPayDialog) {
            PayDialog(viewModel: viewModel)
        }
        .withViewModel(viewModel, navigator) { effect in
            switch onEnum(of: effect) {
            case .showPaymentSheet:
                showPayDialog = true
            case .toast:
                break // TODO: add "toast" support
            }

            return true
        }
    }
}

private struct BillingScreenView: View {
    @State private var showPayDialog: Bool = false
    @State private var showAbortConfirmation = false

    let table: shared.Table
    let state: BillingState
    let abortBill: () -> Void
    let selectAll: () -> Void
    let unselectAll: () -> Void
    let addItem: (_ baseProductId: Int64, _ amount: Int32) -> Void
    let paySelection: (_ paymentSheetShown: Bool) -> Void

    var body: some View {
        ViewStateOverlayView(state: state.paymentState) {
            let billItemsState = onEnum(of: state.billItems)

            if case let .loading(ressource) = billItemsState, ressource.data == nil {
                ProgressView()
            } else {
                if case let .error(resource) = billItemsState {
                    Text("Error \(resource.userMessage())")
                }

                if let billItems = Array(state.billItems.data), !billItems.isEmpty {
                    content(billItems: billItems)
                } else {
                    Text(localize.billing_noOrder(table.groupName, table.number.description))
                }
            }
        }
        .navigationTitle(localize.billing_title(table.groupName, table.number.description))
        .navigationBarTitleDisplayMode(.inline)
        .customBackNavigation(
            title: localize.dialog_cancel(),
            icon: nil
        ) {
            if state.hasCustomSelection {
                showAbortConfirmation = true
            } else {
                abortBill()
            }
        }
        .confirmationDialog(
            localize.billing_notSent_title(),
            isPresented: $showAbortConfirmation,
            titleVisibility: .visible
        ) {
            Button(localize.dialog_closeAnyway(), role: .destructive) {
                abortBill()
            }
        } message: {
            Text(localize.billing_notSent_desc())
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    selectAll()
                } label: {
                    Image(systemName: "checkmark")
                }

                Button {
                    unselectAll()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }

    @ViewBuilder
    private func content(billItems: [BillItem]?) -> some View {
        VStack {
            List {
                if let billItems, !billItems.isEmpty {
                    Section {
                        ForEach(billItems, id: \.baseProductId) { item in
                            BillListItem(
                                item: item,
                                addOne: {
                                    addItem(item.baseProductId, 1)
                                },
                                addAll: {
                                    addItem(item.baseProductId, item.ordered - item.selectedForBill)
                                },
                                removeOne: {
                                    addItem(item.baseProductId, -1)
                                },
                                removeAll: {
                                    addItem(item.baseProductId, -item.selectedForBill)
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
                } else {
                    Text(localize.billing_noOrder(table.groupName, table.number.description))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }

            HStack {
                Text("\(localize.billing_total()):")
                Spacer()
                Text("\(state.priceSum)")
            }
            .font(.title2)
            .padding()
            .overlay(alignment: .bottom) {
                Button {
                    paySelection(false)
                } label: {
                    Image(systemName: "eurosign")
                        .font(.system(.title))
                        .padding()
                        .tint(.white)
                        .offset(x: -3)
                }
                .background(.blue)
                .mask(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                .disabled(state.paymentState != ViewState.Idle.shared || !state.hasSelectedItems)
            }
        }
    }
}
