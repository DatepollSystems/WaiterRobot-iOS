import Foundation
import shared

public enum Mock {
    public static func groupedTables(groups: Int = 1) -> [GroupedTables] {
        let colors = ["ffaaee", "ffeeaa", "eeaaff", nil]
        return (1 ... groups).map { groupId in
            let tableCount = groupId % 3 == 0 ? 4 : 3
            let groupName = "Table Group \(groupId)"

            return GroupedTables(
                id: Int64(groupId),
                name: groupName,
                eventId: 1,
                color: colors[groupId % colors.count],
                tables: (1 ... tableCount).map {
                    table(with: groupId * 10 + $0, hasOrders: $0 % 2 == 0, groupName: groupName)
                }
            )
        }
    }

    public static func tableGroups(groups: Int = 1) -> [TableGroup] {
        groupedTables(groups: groups).map {
            TableGroup(
                id: $0.id,
                name: $0.name,
                color: $0.color,
                hidden: false,
            )
        }
    }

    public static func table(with id: Int, hasOrders: Bool = false, groupName: String = "Hof") -> shared.Table {
        shared.Table(
            id: Int64(id),
            number: Int32(id),
            groupName: groupName,
            hasOrders: hasOrders
        )
    }

    public static func product(with id: Int, soldOut: Bool = false, color: String? = nil, allergens: Set<Character> = []) -> Product {
        Product(
            id: Int64(id),
            name: "Product \(id)",
            price: Money(cents: Int32(id * 10)),
            soldOut: soldOut,
            color: color,
            allergens: allergens.enumerated().map { index, shortName in
                Allergen(id: Int64(index), name: shortName.description, shortName: shortName.description)
            }.filter { $0.shortName.isEmpty == false },
            position: Int32(id),
        )
    }

    public static func productGroups(groups: Int = 1) -> [GroupedProducts] {
        let colors = ["ffaaee", "ffeeaa", "eeaaff", nil].shuffled()
        let allergenList = "ABCDEFG "
        return (1 ... groups).map { groupId in
            let productCount = groupId % 3 == 0 ? 4 : 3
            let groupName = "Product Group \(groupId)"
            return GroupedProducts(
                id: Int64(groupId),
                name: groupName,
                position: Int32(groupId),
                color: colors[groupId % colors.count],
                products: (1 ... productCount).map {
                    let allergens = (0 ... ($0 % 3)).map { _ in
                        allergenList.randomElement()!
                    }
                    return product(with: groupId * 10 + $0, soldOut: $0 % 5 == 2, allergens: Set(allergens))
                },
            )
        }
    }
}
