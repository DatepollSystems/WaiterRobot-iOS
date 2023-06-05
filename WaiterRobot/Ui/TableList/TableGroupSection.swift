import SwiftUI
import shared

struct TableGroupSection: View {
  
  let groupWithTables: TableGroupWithTables
  let onTableClick: (shared.Table) -> Void
  
  var body: some View {
    Section {
      ForEach(groupWithTables.tables, id: \.id) { table in
        Table(
          text: table.number.description,
          onClick: {
            onTableClick(table)
          }
        )
        .padding(10)
      }
    }  header: {
      HStack {
        Color(UIColor.lightGray).frame(height: 1)
        Text(groupWithTables.group.name)
        Color(UIColor.lightGray).frame(height: 1)
      }
    }
  }
}

struct TableGroupSection_Previews: PreviewProvider {
  static var previews: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
      TableGroupSection(
        groupWithTables: TableGroupWithTables(
          group: TableGroup(id: 1, name: "Test Group"),
          tables: [
            shared.Table(id: 1, number: 1),
            shared.Table(id: 2, number: 2),
            shared.Table(id: 3, number: 3),
            shared.Table(id: 4, number: 4),
          ]),
        onTableClick: { _ in }
      )
    }.padding()
  }
}
