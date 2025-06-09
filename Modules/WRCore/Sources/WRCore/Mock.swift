import Foundation
import shared

public enum Mock {
    public static func groupedTables() -> [GroupedTables] {
        [
            GroupedTables(
                id: 1,
                name: "Hof",
                eventId: 1,
                color: nil,
                tables: [
                    table(with: 1),
                    table(with: 2),
                    table(with: 3),
                ]
            ),
        ]
    }

    public static func tableGroups() -> [TableGroup] {
        groupedTables().map {
            TableGroup(
                id: $0.id,
                name: $0.name,
                color: $0.color,
                hidden: false,
            )
        }
    }

    public static func table(with id: Int64, hasOrders: Bool = false) -> shared.Table {
        shared.Table(
            id: id,
            number: Int32(id),
            groupName: "Hof",
            hasOrders: hasOrders
        )
    }
}
