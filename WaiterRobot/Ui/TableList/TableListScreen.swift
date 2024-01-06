import shared
import SwiftUI
import UIPilot

struct TableListScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var strongVM = TableListObservableViewModel()

    private let layout = [
        GridItem(.adaptive(minimum: 100)),
    ]

    // TODO: table has open/unpaid order indicator
    var body: some View {
        unowned let vm = strongVM

        let tableGroupResource = onEnum(of: vm.state.tableGroupsArray)

        VStack {
            if case let .error(resource) = tableGroupResource {
                Text(resource.exception.getLocalizedUserMessage())
            } else if case let .loading(resource) = tableGroupResource {
                ProgressView()
            } else if case let .success(resource) = tableGroupResource {
                if let tableGroupsArray = resource.data {
                    let tableGroups = Array(tableGroupsArray)
                    if tableGroups.count > 1 {
                        TableListFilterRow(
                            tableGroups: tableGroups,
                            onToggleFilter: { vm.actual.toggleFilter(tableGroup: $0) },
                            onSelectAll: { vm.actual.showAll() },
                            onUnselectAll: { vm.actual.hideAll() }
                        )
                    }

                    ScrollView {
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

//                if tableGroups?.isEmpty == true {
//                    Text(localize.tableList.noTableFound())
//                        .multilineTextAlignment(.center)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                } else if let tableGroups {
//
//                }
//            }
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
