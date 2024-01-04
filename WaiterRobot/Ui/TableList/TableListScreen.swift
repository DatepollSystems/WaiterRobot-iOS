import shared
import SwiftUI
import UIPilot

struct TableListScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var strongVM = ObservableViewModel(vm: koin.tableListVM())

    private let layout = [
        GridItem(.adaptive(minimum: 100)),
    ]

    // TODO: table has open/unpaid order indicator
    var body: some View {
        unowned let vm = strongVM

        let tableGroups = vm.state.tableGroups.data as? [TableGroup]
        let tableGroupResource = onEnum(of: vm.state.tableGroups)
        VStack {
            if let tableGroups, tableGroups.count > 1 {
                TableListFilterRow(
                    tableGroups: tableGroups,
                    onToggleFilter: { vm.actual.toggleFilter(tableGroup: $0) },
                    onSelectAll: { vm.actual.showAll() },
                    onUnselectAll: { vm.actual.hideAll() }
                )
            }

            RefreshableScrollView(for: tableGroupResource, onRefresh: { vm.actual.loadTables(forceUpdate: true) }) {
                if case let .error(resource) = tableGroupResource {
                    Text(resource.exception.getLocalizedUserMessage())
                }

                if tableGroups?.isEmpty == true {
                    Text(localize.tableList.noTableFound())
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else if let tableGroups {
                    LazyVGrid(columns: layout) {
                        ForEach(tableGroups.filter { !$0.hidden }, id: \.id) { group in
                            if !group.tables.isEmpty {
                                TableGroupSection(
                                    tableGroup: group,
                                    onTableClick: { vm.actual.onTableClick(table: $0) }
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(CommonApp.shared.settings.eventName)
        .navigationBarTitleDisplayMode(.large)
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
