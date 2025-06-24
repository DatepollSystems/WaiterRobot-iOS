import shared
import SwiftUI
import WRCore

struct AllProductGroupList: View {
    let productGroups: [GroupedProducts]
    let onProductClick: (Product) -> Void

    var body: some View {
        ScrollView {
            ForEach(productGroups, id: \.id) { productGroup in
                if !productGroup.products.isEmpty {
                    Section {
                        ProductGroupList(
                            products: productGroup.products,
                            backgroundColor: Color(hex: productGroup.color),
                            onProductClick: onProductClick
                        )
                    } header: {
                        HStack {
                            Color(UIColor.lightGray).frame(height: 1)
                            Text(productGroup.name)
                            Color(UIColor.lightGray).frame(height: 1)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AllProductGroupList(
        productGroups: Mock.productGroups(groups: 3),
        onProductClick: { _ in }
    )
    .padding()
}
