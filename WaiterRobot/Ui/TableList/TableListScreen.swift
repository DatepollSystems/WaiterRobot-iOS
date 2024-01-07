import shared
import SwiftUI
import UIPilot

struct TableListScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableTableListViewModel()

    private let layout = [
        GridItem(.adaptive(minimum: 100)),
    ]

    var body: some View {
        VStack {
            switch onEnum(of: viewModel.state.tableGroupsArray) {
            case let .error(resource):
                Text(resource.exception.getLocalizedUserMessage())
                    .foregroundStyle(.red)

            case let .loading(resource):
                if resource.data == nil {
                    ProgressView()
                }

            case .success:
                EmptyView()
            }

            if let data = viewModel.state.tableGroupsArray.data {
                let tableGroups = Array(data)
                content(tableGroups: tableGroups)
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

    // TODO: table has open/unpaid order indicator
    @ViewBuilder
    private func content(tableGroups: [TableGroup]) -> some View {
        if tableGroups.count > 1 {
            TableListFilterRow(
                tableGroups: tableGroups,
                onToggleFilter: { viewModel.actual.toggleFilter(tableGroup: $0) },
                onSelectAll: { viewModel.actual.showAll() },
                onUnselectAll: { viewModel.actual.hideAll() }
            )
        }

        if tableGroups.isEmpty {
            Text(localize.tableList.noTableFound())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
        } else {
            ScrollView {
                LazyVGrid(columns: layout) {
                    ForEach(tableGroups.filter { !$0.hidden }, id: \.id) { group in
                        if !group.tables.isEmpty {
                            TableGroupSection(
                                tableGroup: group,
                                onTableClick: { viewModel.actual.onTableClick(table: $0) }
                            )
                        }
                    }
                }
                .padding()
            }
        }
    }
}
