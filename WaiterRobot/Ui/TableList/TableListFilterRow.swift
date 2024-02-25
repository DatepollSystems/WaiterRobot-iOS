import shared
import SwiftUI

struct TableListFilterRow: View {
    let tableGroups: [TableGroup]
    let onToggleFilter: (TableGroup) -> Void
    let onSelectAll: () -> Void
    let onUnselectAll: () -> Void

    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(tableGroups, id: \.id) { group in
                        Button {
                            onToggleFilter(group) // viewModel.actual.toggleFilter(tableGroup: group)
                        } label: {
                            Text(group.name)
                        }
                        .buttonStyle(.bordered)
                        .tint(group.hidden ? .primary : .blue)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 4)

            Button {
                onUnselectAll()
            } label: {
                Image(systemName: "xmark")
            }
            .padding(.trailing)
            .disabled(tableGroups.allSatisfy(\.hidden))
            Button {
                onSelectAll()
            } label: {
                Image(systemName: "checkmark")
            }
            .padding(.trailing)
            .disabled(tableGroups.allSatisfy { !$0.hidden })
        }
    }
}

struct TableListFilterRow_Previews: PreviewProvider {
    static var previews: some View {
        TableListFilterRow(
            tableGroups: [
                TableGroup(id: 1, name: "Test Group1", eventId: 1, position: 1, color: nil, hidden: false, tables: []),
                TableGroup(id: 2, name: "Test Group2", eventId: 1, position: 1, color: nil, hidden: false, tables: []),
            ],
            onToggleFilter: { _ in },
            onSelectAll: {},
            onUnselectAll: {}
        )
    }
}
