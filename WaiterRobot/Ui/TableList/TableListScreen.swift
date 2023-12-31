import shared
import SwiftUI
import UIPilot

struct TableListScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableViewModel(viewModel: koin.tableListVM())

    private let layout = [
        GridItem(.adaptive(minimum: 100)),
    ]

    var body: some View {
        ScreenContainer(viewModel.state) {
            VStack {
                if (viewModel.state.unselectedTableGroupList.count + viewModel.state.selectedTableGroupList.count) > 1 {
                    TableListFilterRow(
                        selectedTableGroups: viewModel.state.selectedTableGroupList,
                        unselectedTableGroups: viewModel.state.unselectedTableGroupList,
                        onToggleFilter: { viewModel.actual.toggleFilter(tableGroup: $0) },
                        onClearFilter: viewModel.actual.clearFilter
                    )
                }

                ScrollView {
                    if viewModel.state.filteredTableGroups.isEmpty {
                        Text(localize.tableList.noTableFound())
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        LazyVGrid(columns: layout) {
                            ForEach(viewModel.state.filteredTableGroups, id: \.group.id) { groupWithTables in
                                if !groupWithTables.tables.isEmpty {
                                    TableGroupSection(
                                        groupWithTables: groupWithTables,
                                        onTableClick: viewModel.actual.onTableClick
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
                .refreshable {
                    viewModel.actual.loadTables(forceUpdate: true)
                }
            }
        }
        .navigationTitle(CommonApp.shared.settings.eventName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.actual.openSettings()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .handleSideEffects(of: viewModel, navigator)
    }
}
