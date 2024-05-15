import shared
import SwiftUI

struct ProductSearchGroupList: View {
    let products: [Product]
    let onProductClick: (Product) -> Void

    var body: some View {
        ForEach(products, id: \.id) { product in
            ProductListItem(product: product) {
                onProductClick(product)
            }
            .foregroundColor(.blackWhite)
            .padding(10)
        }
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))]) {
        ProductSearchGroupList(
            products: [
                Product(
                    id: 1,
                    name: "Beer",
                    price: Money(cents: 450),
                    soldOut: false,
                    allergens: [],
                    position: 1
                ),
            ],
            onProductClick: { _ in }
        )
    }
}
