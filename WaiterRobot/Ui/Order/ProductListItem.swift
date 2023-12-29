import shared
import SwiftUI

struct ProductListItem: View {
    let product: Product
    let onClick: () -> Void

    private let allergens: String

    init(product: Product, onClick: @escaping () -> Void) {
        self.product = product
        self.onClick = onClick

        var allergens = ""
        self.product.allergens.forEach { allergen in
            allergens += "\(allergen.shortName), "
        }

        if allergens.count > 2 {
            self.allergens = String(allergens.prefix(allergens.count - 2))
        } else {
            self.allergens = ""
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(product.soldOut ? Color.gray.opacity(0.1) : Color(.systemBackground))
                .shadow(radius: 2)

            Button {
                onClick()
            } label: {
                VStack {
                    Text(product.name)
                        .strikethrough(product.soldOut)
                    if !product.allergens.isEmpty {
                        Text(allergens)
                            .foregroundColor(.gray)
                    }
                    Text(product.price.description())
                }
                .foregroundColor(.blackWhite)
                .frame(maxWidth: .infinity)
                .padding(5)
            }
            .disabled(product.soldOut)
        }
    }
}

struct ProductListItem_Previews: PreviewProvider {
    static var previews: some View {
        ProductListItem(
            product: Product(
                id: 2,
                name: "Wine",
                price: Money(cents: 290),
                soldOut: true,
                allergens: [
                    Allergen(id: 1, name: "Egg", shortName: "E"),
                    Allergen(id: 2, name: "Egg2", shortName: "A"),
                    Allergen(id: 3, name: "Egg3", shortName: "B"),
                    Allergen(id: 4, name: "Egg4", shortName: "C"),
                    Allergen(id: 5, name: "Egg5", shortName: "D"),
                ],
                position: 1
            ),
            onClick: {}
        )
    }
}
