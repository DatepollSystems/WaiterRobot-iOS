import shared
import SwiftUI
import UIPilot
import WRCore

struct TableGroupFilterSheet: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = ObservableTableGroupFilterViewModel()

    var body: some View {
        NavigationView {
            content()
                .observeState(of: viewModel)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(localize.dialog_cancel()) {
                            dismiss()
                        }
                    }
                }
        }
    }

    @ViewBuilder
    private func content() -> some View {
        switch onEnum(of: viewModel.state.groups) {
        case .loading:
            ProgressView()
        case let .error(resource):
            Text(resource.userMessage())
        case let .success(resource):
            TableGroupFilter(
                groups: Array(resource.data) ?? [],
                showAll: { viewModel.actual.showAll() },
                hideAll: { viewModel.actual.hideAll() },
                onToggle: { viewModel.actual.toggleFilter(tableGroup: $0) }
            )
        }
    }
}

private struct TableGroupFilter: View {
    let groups: [TableGroup]
    let showAll: () -> Void
    let hideAll: () -> Void
    let onToggle: (TableGroup) -> Void

    var body: some View {
        if groups.isEmpty {
            // Should not happen as open filter is only shown when there are groups
            Text(localize.tableList_noTableFound())
        } else {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(groups, id: \.id) { group in
                        HStack {
                            Circle()
                                .fill(Color(hex: group.color) ?? Color.gray.opacity(0.3))
                                .frame(height: 40)

                            Text(group.name)

                            Spacer()

                            Toggle(
                                isOn: .init(
                                    get: { !group.hidden },
                                    set: { _ in onToggle(group) }
                                ),
                                label: {}
                            ).labelsHidden()
                        }.padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    TableGroupFilter(
        groups: [
            shared.TableGroup(id: 1, name: "Group 1", color: "ffaaff", hidden: false),
            shared.TableGroup(id: 2, name: "Group 2", color: "aaffaa", hidden: false),
        ],
        showAll: {},
        hideAll: {},
        onToggle: { _ in }
    )
}
