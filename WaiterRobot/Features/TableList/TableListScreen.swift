import shared
import SwiftUI
import UIPilot
import WRCore

struct TableListScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableTableListViewModel()

    @State
    private var showFilters = false

    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                content()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showFilters.toggle()
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease")
                            }
                        }
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
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                showFilters.toggle()
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease")
                            }
                        }

                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                viewModel.actual.openSettings()
                            } label: {
                                Image(systemName: "gear")
                            }
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    HStack(spacing: 0) {
                        Text("kellner.")
                            .textStyle(.h4, textColor: .title)

                        Text("team")
                            .textStyle(.h4, textColor: .palletOrange)
                    }

                    Text(CommonApp.shared.settings.eventName)
                        .textStyle(.caption1)
                        .padding(.bottom, 6)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring, value: viewModel.state.tableGroups)
        .sheet(isPresented: $showFilters) {
            TableGroupFilterSheet()
        }
        .withViewModel(viewModel, navigator)
    }

    private func content() -> some View {
        ZStack {
            if let tableGroups = Array(viewModel.state.tableGroups.data) {
                TableListView(
                    tableGroups: tableGroups,
                    onTableSelect: { viewModel.actual.onTableClick(table: $0) }
                )
            } else {
                ProgressView()
            }

            switch onEnum(of: viewModel.state.tableGroups) {
            case let .error(resource):
                VStack {
                    Spacer()

                    HStack {
                        Text(resource.userMessage())
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
}

struct TableListView: View {
    let tableGroups: [GroupedTables]
    let onTableSelect: (shared.Table) -> Void

    private let layout = [
        GridItem(.adaptive(minimum: 100)),
    ]

    var body: some View {
        VStack(spacing: 0) {
            if tableGroups.isEmpty {
                Spacer()

                Text(localize.tableList_noTableFound())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()

                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: layout,
                        pinnedViews: [.sectionHeaders]
                    ) {
                        ForEach(tableGroups, id: \.id) { group in
                            if !group.tables.isEmpty {
                                TableGroupSection(
                                    groupedTables: group,
                                    onTableClick: onTableSelect
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

#Preview("TableListScreen") {
    PreviewView {
        NavigationView {
            TableListScreen()
        }
    }
}

#Preview("TableListView") {
    PreviewView {
        NavigationView {
            TableListView(
                tableGroups: Mock.groupedTables(),
                onTableSelect: { _ in }
            )
        }
    }
}
