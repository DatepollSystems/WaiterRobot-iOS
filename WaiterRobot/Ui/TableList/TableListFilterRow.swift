import shared
import SwiftUI

struct TableListFilterRow: View {
	let selectedTableGroups: [TableGroup]
	let unselectedTableGroups: [TableGroup]
	let onToggleFilter: (TableGroup) -> Void
	let onClearFilter: () -> Void

	var body: some View {
		HStack {
			ScrollView(.horizontal) {
				HStack {
					ForEach(selectedTableGroups, id: \.id) { group in
						Button {
							onToggleFilter(group) // vm.actual.toggleFilter(tableGroup: group)
						} label: {
							Text(group.name)
						}
						.buttonStyle(.bordered)
						.tint(.blue)
					}

					ForEach(unselectedTableGroups, id: \.id) { group in
						Button {
							onToggleFilter(group)
						} label: {
							Text(group.name)
						}
						.buttonStyle(.bordered)
					}
				}.padding(.horizontal)
			}
			Button {
				onClearFilter()
			} label: {
				Image(systemName: "xmark")
			}
			.padding()
			.disabled(selectedTableGroups.isEmpty)
		}
	}
}

struct TableListFilterRow_Previews: PreviewProvider {
	static var previews: some View {
		TableListFilterRow(
			selectedTableGroups: [
				TableGroup(id: 1, name: "Test Group1"),
				TableGroup(id: 2, name: "Test Group2"),
			],
			unselectedTableGroups: [
				TableGroup(id: 3, name: "Test Group3"),
			],
			onToggleFilter: { _ in },
			onClearFilter: {}
		)
	}
}
