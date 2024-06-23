import shared
import SharedUI
import SwiftUI
import WRCore

struct TableGroupSection: View {
    let tableGroup: TableGroup
    let onTableClick: (shared.Table) -> Void

    var body: some View {
        Section {
            ForEach(tableGroup.tables, id: \.id) { table in
                TableView(
                    text: table.number.description,
                    hasOrders: table.hasOrders,
                    onClick: {
                        onTableClick(table)
                    }
                )
                .padding(10)
            }
        } header: {
            HStack {
                Text(tableGroup.name)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(6)
                    .background {
                        RoundedRectangle(cornerRadius: 8.0)
                            .foregroundStyle(Color.accent)
                    }

                Spacer()
            }
            .padding(.vertical, 4)
            .background(Color.whiteBlack)
        }
    }
}

#Preview {
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
    }
    .padding()
}
