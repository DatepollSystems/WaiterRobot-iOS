import shared
import SwiftUI
import WRCore

struct ProductGroupList: View {
    let products: [Product]
    let backgroundColor: Color?
    let onProductClick: (Product) -> Void

    private let layout = [
        GridItem(.adaptive(minimum: 110)),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout, spacing: 0) {
                ForEach(products, id: \.id) { product in
                    ProductListItem(product: product, backgroundColor: backgroundColor) {
                        onProductClick(product)
                    }
                    .foregroundColor(.blackWhite)
                    .padding(10)
                }
            }
        }
    }
}

#Preview {
    ProductGroupList(
        products: [
            Mock.product(with: 1),
            Mock.product(with: 2, soldOut: true, allergens: ["A"]),
            Mock.product(with: 3, color: "ffaa00", allergens: ["A"]),
            Mock.product(with: 4, soldOut: true, color: "ffaa00"),
        ],
        backgroundColor: .yellow,
        onProductClick: { _ in }
    )
}
