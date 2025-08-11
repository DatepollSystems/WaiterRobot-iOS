import shared
import SharedUI
import SwiftUI
import WRCore

struct ProductTabView: View {
    let productGroups: [GroupedProducts]
    let addItem: (_ product: Product, _ amount: Int32) -> Void

    @State private var selectedTab: Int = 0

    var body: some View {
        if productGroups.isEmpty {
            Text(localize.productSearch_noProductFound())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
        } else {
            VStack {
                TabBarHeader(
                    currentTab: $selectedTab,
                    tabBarOptions: getGroupNames(productGroups)
                )

                TabView(selection: $selectedTab) {
                    AllProductGroupList(
                        productGroups: productGroups,
                        onProductClick: { addItem($0, 1) }
                    )
                    .tag(0)
                    .padding()

                    let enumeratedProductGroups = Array(productGroups.enumerated())
                    ForEach(enumeratedProductGroups, id: \.element.id) { index, groupedProducts in
                        ProductGroupList(
                            products: groupedProducts.products,
                            backgroundColor: Color(hex: groupedProducts.color),
                            onProductClick: { addItem($0, 1) }
                        ).padding()
                            .tag(index + 1)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    private func getGroupNames(_ productGroups: [GroupedProducts]) -> [String] {
        var groupNames = productGroups.map { productGroup in
            productGroup.name
        }
        groupNames.insert(localize.productSearch_groups_all(), at: 0)
        return groupNames
    }
}

#Preview {
    ProductTabView(
        productGroups: Mock.productGroups(groups: 3),
        addItem: { _, _ in }
    )
}
