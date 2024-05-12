import shared
import SwiftUI
import UIPilot

struct TableListScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableTableListViewModel()

    private let layout = [
        GridItem(.adaptive(minimum: 100)),
    ]

    @State
    private var showFilters = false

    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                content()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                viewModel.actual.openSettings()
                            } label: {
                                Image(systemName: "gear")
                            }
                        }
                    }
                    .toolbarBackground(.hidden, for: .navigationBar)
            } else {
                content()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewModel.actual.openSettings()
                            } label: {
                                Image(systemName: "gear")
                            }
                        }
                    }
            }
        }
        .navigationTitle(CommonApp.shared.settings.eventName)
        .navigationBarTitleDisplayMode(.inline)
        .handleSideEffects(of: viewModel, navigator)
        .animation(.spring, value: viewModel.state.tableGroupsArray)
        .onAppear {
            viewModel.activate()
        }
        .onDisappear {
            viewModel.deactivate()
        }
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
            if tableGroups.count > 1, showFilters {
                VStack {
                    TableListFilterRow(
                        tableGroups: tableGroups,
                        onToggleFilter: { viewModel.actual.toggleFilter(tableGroup: $0) },
                        onSelectAll: { viewModel.actual.showAll() },
                        onUnselectAll: { viewModel.actual.hideAll() }
                    )
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }

            Divider()

            if tableGroups.isEmpty {
                Spacer()

                Text(localize.tableList.noTableFound())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()

                Spacer()
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
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if tableGroups.count > 1 {
                            Button {
                                showFilters.toggle()
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                            }
                        }
                    }
                }
            }
        }
        .animation(.easeIn, value: showFilters)
    }
}

#Preview {
    PreviewView {
        NavigationView {
            TableListScreen()
        }
    }
}
