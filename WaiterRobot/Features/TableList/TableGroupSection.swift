import shared
import SharedUI
import SwiftUI
import WRCore

struct TableGroupSection: View {
    @Environment(\.self)
    private var env

    let groupedTables: GroupedTables
    let onTableClick: (shared.Table) -> Void

    var body: some View {
        Section {
            ForEach(groupedTables.tables, id: \.id) { table in
                TableView(
                    text: table.number.description,
                    hasOrders: table.hasOrders,
                    backgroundColor: Color(hex: groupedTables.color),
                    onClick: {
                        onTableClick(table)
                    }
                )
                .padding(10)
            }
        } header: {
            HStack {
                if let background = Color(hex: groupedTables.color) {
                    title(backgroundColor: background)
                } else {
                    title(backgroundColor: Color.lightGray)
                }

                Spacer()
            }
            .padding(.vertical, 4)
            .background(Color.whiteBlack)
        }
    }

    private func title(backgroundColor: Color) -> some View {
        Text(groupedTables.name)
            .font(.title2)
            .foregroundStyle(backgroundColor.bestContrastColor(.black, .white, in: env))
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 8.0)
                    .foregroundStyle(backgroundColor)
            }
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
        TableGroupSection(
            groupedTables: Mock.groupedTables().first!,
            onTableClick: { _ in }
        )
    }
    .padding()
}
