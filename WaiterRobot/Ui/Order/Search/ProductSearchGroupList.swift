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
            .foregroundColor(Color("textColor"))
            .padding(10)
        }
    }
}

struct ProductSearchGroupList_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))]) {
            ProductSearchGroupList(
                products: [
                    Product(
                        id: 1,
                        name: "Beer",
                        price: Money(cents: 450),
                        soldOut: false,
                        allergens: []
                    ),
                ],
                onProductClick: { _ in }
            )
        }
    }
}
