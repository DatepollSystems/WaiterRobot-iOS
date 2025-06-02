import Foundation
import shared

public enum Mock {
    public static func tableGroups() -> [TableGroup] {
        [
            tableGroup(with: 1, name: "Hof"),
            tableGroup(with: 2, name: "Terasse"),
            tableGroup(with: 3, name: "Zimmer A"),
        ]
    }

    public static func tableGroup(with id: Int64, name: String = "Hof") -> TableGroup {
        TableGroup(
            id: id,
            name: name,
            color: "",
            hidden: false,
        )
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
