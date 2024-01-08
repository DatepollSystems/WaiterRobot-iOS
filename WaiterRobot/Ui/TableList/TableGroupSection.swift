import shared
import SwiftUI

struct TableGroupSection: View {
    let tableGroup: TableGroup
    let onTableClick: (shared.Table) -> Void

    var body: some View {
        Section {
            ForEach(tableGroup.tables, id: \.id) { table in
                TableView(
                    text: table.number.description,
                    onClick: {
                        onTableClick(table)
                    }
                )
                .padding(10)
            }
        } header: {
            HStack {
                Color(UIColor.lightGray).frame(height: 1)
                Text(tableGroup.name)
                Color(UIColor.lightGray).frame(height: 1)
            }
        }
    }
}

struct TableGroupSection_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            TableGroupSection(
                tableGroup: TableGroup(
                    id: 1,
                    name: "Test Group",
                    eventId: 1,
                    position: 1,
                    color: nil,
                    hidden: false,
                    tables: [
                        shared.Table(id: 1, number: 1, groupName: "Test Group", hasOrders: true),
                        shared.Table(id: 2, number: 2, groupName: "Test Group", hasOrders: false),
                        shared.Table(id: 3, number: 3, groupName: "Test Group", hasOrders: false),
                        shared.Table(id: 4, number: 4, groupName: "Test Group", hasOrders: true),
                    ]
                ),
                onTableClick: { _ in }
            )
        }.padding()
    }
}
