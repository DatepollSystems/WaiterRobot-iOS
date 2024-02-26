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
        content()
            .navigationTitle(CommonApp.shared.settings.eventName)
            .navigationBarTitleDisplayMode(.inline)
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
            .animation(.spring, value: viewModel.state.tableGroupsArray)
    }

    private func content() -> some View {
        ZStack {
            if let data = viewModel.state.tableGroupsArray.data {
                tableList(data: data)
            }

            switch onEnum(of: viewModel.state.tableGroupsArray) {
            case let .error(resource):
                VStack {
                    Spacer()

                    HStack {
                        Text(resource.userMessage)
                            .padding()

                        Spacer()
                    }
                    .background(.red)
                    .foregroundStyle(.white)
                }
                .transition(.move(edge: .bottom))

            case let .loading(resource):
                if resource.data == nil {
                    ProgressView()
                }

            case .success:
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private func tableList(data: KotlinArray<TableGroup>) -> some View {
        let tableGroups = Array(data)

        VStack(spacing: 0) {
            if tableGroups.count > 1 {
                VStack {
                    TableListFilterRow(
                        tableGroups: tableGroups,
                        onToggleFilter: { viewModel.actual.toggleFilter(tableGroup: $0) },
                        onSelectAll: { viewModel.actual.showAll() },
                        onUnselectAll: { viewModel.actual.hideAll() }
                    )

                    Divider()
                }
                .background(Color(UIColor.systemBackground))
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
}

#Preview {
    PreviewView {
        TableListScreen()
    }
}
