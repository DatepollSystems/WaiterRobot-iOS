import shared
import SwiftUI
import UIPilot

struct TableListScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var strongVM = ObservableViewModel(vm: koin.tableListVM())

    private let layout = [
        GridItem(.adaptive(minimum: 100)),
    ]

    var body: some View {
        unowned let vm = strongVM

        ScreenContainer(vm.state) {
            VStack {
                TableListFilterRow(
                    selectedTableGroups: vm.state.selectedTableGroupList,
                    unselectedTableGroups: vm.state.unselectedTableGroupList,
                    onToggleFilter: { vm.actual.toggleFilter(tableGroup: $0) },
                    onClearFilter: vm.actual.clearFilter
                )

                ScrollView {
                    if vm.state.filteredTableGroups.isEmpty {
                        Text(localize.tableList.noTableFound())
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        LazyVGrid(columns: layout) {
                            ForEach(vm.state.filteredTableGroups, id: \.group.id) { groupWithTables in
                                if !groupWithTables.tables.isEmpty {
                                    TableGroupSection(
                                        groupWithTables: groupWithTables,
                                        onTableClick: vm.actual.onTableClick
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
                .refreshable {
                    vm.actual.loadTables(forceUpdate: true)
                }
            }
        }
        .navigationTitle(CommonApp.shared.settings.eventName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.actual.openSettings()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .handleSideEffects(of: vm, navigator)
    }
}
