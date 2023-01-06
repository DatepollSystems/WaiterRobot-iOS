import SwiftUI
import shared

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
      self.allergens = "-"
    }
  }
  
  var body: some View {
    Button {
      onClick()
    } label: {
      HStack {
        VStack(alignment: .leading) {
          Text(product.name)
          Text(allergens)
            .foregroundColor(.gray)
        }
        Spacer()
        Text(product.price.description())
      }
      .foregroundColor(Color("textColor"))
    }.disabled(product.soldOut)
      .conditionalModifier(product.soldOut) { view in
        view.listRowBackground(Color.gray.opacity(0.3))
      }
  }
}

struct ProductListItem_Previews: PreviewProvider {
  static var previews: some View {
    List {
      ProductListItem(
        product: Product(
          id: 1,
          name: "Beer",
          price: Money(cents: 390),
          soldOut: false,
          allergens: [Allergen(id: 1, name: "Egg", shortName: "E")],
          productGroup: ProductGroup(id: 1, name: "Test Group")
        ),
        onClick: {}
      )
      ProductListItem(
        product: Product(
          id: 1,
          name: "Beer",
          price: Money(cents: 390),
          soldOut: false,
          allergens: [],
          productGroup: ProductGroup(id: 1, name: "Test Group")
        ),
        onClick: {}
      )
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
          productGroup: ProductGroup(id: 1, name: "Test Group")
        ),
        onClick: {}
      )
    }
  }
}
