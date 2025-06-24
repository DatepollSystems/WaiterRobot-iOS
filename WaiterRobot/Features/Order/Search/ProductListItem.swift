import shared
import SwiftUI
import WRCore

struct ProductListItem: View {
    let product: Product
    let backgroundColor: Color?
    let onClick: () -> Void

    private let allergens: String

    init(
        product: Product,
        backgroundColor: Color?,
        onClick: @escaping () -> Void
    ) {
        self.product = product
        if let color = product.color {
            self.backgroundColor = Color(hex: color)
        } else {
            self.backgroundColor = backgroundColor
        }

        var allergens = ""
        for allergen in self.product.allergens {
            allergens += "\(allergen.shortName), "
        }
        if allergens.count > 2 {
            self.allergens = String(allergens.prefix(allergens.count - 2))
        } else {
            self.allergens = ""
        }

        self.onClick = onClick
    }

    var foregroundColor: Color {
        if product.soldOut {
            .blackWhite
        } else if let backgroundColor {
            backgroundColor.getContentColor(lightColorScheme: .black, darkColorScheme: .white)
        } else {
            .blackWhite
        }
    }

    var body: some View {
        Button {
            onClick()
        } label: {
            VStack {
                Text(product.name)
                    .strikethrough(product.soldOut)
                    .foregroundStyle(foregroundColor)
                if !product.allergens.isEmpty {
                    Text(allergens)
                        .foregroundStyle(foregroundColor)
                        .opacity(0.6)
                }
                Text(product.price.description())
            }
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(5)
        }
        .disabled(product.soldOut)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(product.soldOut ? Color.gray.opacity(0.1) : backgroundColor ?? Color(.systemBackground))
                .shadow(radius: 2)
        }
    }
}

#Preview {
    ProductListItem(
        product: Mock.product(with: 1, soldOut: false, color: "ffaaee", allergens: ["A"]),
        backgroundColor: .red,
        onClick: {}
    )
    .frame(maxWidth: 100, maxHeight: 100)
}

#Preview {
    ProductListItem(
        product: Mock.product(with: 1, soldOut: true, color: "ffaaee", allergens: ["A", "B"]),
        backgroundColor: .red,
        onClick: {}
    )
    .frame(maxWidth: 100, maxHeight: 100)
}
