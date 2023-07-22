import shared
import SwiftUI

struct ProductSearchAllTab: View {
	let productGroups: [ProductGroupWithProducts]
	let columns: [GridItem]
	let onProductClick: (Product) -> Void

	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(productGroups, id: \.group.id) { groupWithProducts in
					if !groupWithProducts.products.isEmpty {
						Section {
							ProductSearchGroupList(
								products: groupWithProducts.products,
								onProductClick: onProductClick
							)
						} header: {
							HStack {
								Color(UIColor.lightGray).frame(height: 1)
								Text(groupWithProducts.group.name)
								Color(UIColor.lightGray).frame(height: 1)
							}
						}
					}
				}
				Spacer()
			}
		}
	}
}

struct ProductSearchAllTab_Previews: PreviewProvider {
	static var previews: some View {
		ProductSearchAllTab(
			productGroups: [
				ProductGroupWithProducts(
					group: ProductGroup(
						id: 1,
						name: "Test Group 1"
					),
					products: [
						Product(
							id: 1,
							name: "Beer",
							price: Money(cents: 450),
							soldOut: false,
							allergens: []
						),
					]
				),
			],
			columns: [GridItem(.adaptive(minimum: 110))],
			onProductClick: { _ in }
		)
		.padding()
	}
}
