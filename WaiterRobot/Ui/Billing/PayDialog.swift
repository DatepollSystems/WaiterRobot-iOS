import Combine
import shared
import SwiftUI

struct PayDialog: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var vm: ObservableViewModel<BillingState, BillingEffect, BillingViewModel>

    @State private var moneyGiven: String = "" {
        didSet {
            let range = NSRange(location: 0, length: moneyGiven.utf16.count)
            guard let regex = try? NSRegularExpression(pattern: "^(\\d+([.,]\\d{0,2})?)?$") else {
                return
            }

            isInputInvalid = vm.state.changeText == "NaN" || vm.state.changeText.hasPrefix("-") || regex.firstMatch(in: moneyGiven, options: [], range: range) == nil
        }
    }

    @State private var isInputInvalid = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(localize.billing.total() + ":")
                        .font(.title2)
                    Spacer()
                    Text(vm.state.priceSum.description)
                        .font(.title2)
                }

                TextField(localize.billing.given(), text: $moneyGiven)
                    .font(.title)
                    .keyboardType(.numbersAndPunctuation)
                    .onChange(of: moneyGiven, perform: vm.actual.moneyGiven)
                    .frame(height: 48)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(isInputInvalid ? .red : .secondary, lineWidth: 2.0)
                    )

                HStack {
                    Text(localize.billing.change() + ":")
                        .font(.title2)
                    Spacer()
                    Text(vm.state.changeText)
                        .font(.title2)
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localize.dialog.cancel()) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(localize.billing.pay()) {
                        vm.actual.paySelection()
                        dismiss()
                    }
                }
            }
        }
    }
}
