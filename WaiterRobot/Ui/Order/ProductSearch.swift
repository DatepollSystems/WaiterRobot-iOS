import SwiftUI
import shared

struct ProductSearch: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var vm: ObservableViewModel<OrderState, OrderEffect, OrderViewModel>
    
    @State private var search: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.state.products, id: \.id) { product in
                    ProductListItem(product: product) {
                        vm.actual.addItem(product: product, amount: 1)
                        dismiss()
                    }
                    .foregroundColor(Color("textColor"))
                }
            }
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: search, perform: vm.actual.filterProducts)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(S.dialog.cancel()) {
                        dismiss()
                    }
                }
            }
        }
    }
}
