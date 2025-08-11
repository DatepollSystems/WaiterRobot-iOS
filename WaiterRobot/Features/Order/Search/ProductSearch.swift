import shared
import SwiftUI
import WRCore

struct ProductSearch: View {
    let addItem: (_ product: Product, _ amount: Int32) -> Void

    @Environment(\.dismiss) private var dismiss

    @ObservedObject private var viewModel = ObservableProductListViewModel()

    @State private var search: String = ""
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            content()
                .observeState(of: viewModel)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(localize.dialog_cancel()) {
                            dismiss()
                        }
                    }
                }
        }
    }

    @ViewBuilder
    private func content() -> some View {
        switch onEnum(of: viewModel.state.productGroups) {
        case .loading:
            ProgressView()
        case let .error(resource):
            productGroupsError(error: resource)
        case let .success(resource):
            if let productGroups = Array(resource.data) {
                ProductTabView(
                    productGroups: productGroups,
                    addItem: {
                        addItem($0, $1)
                        dismiss()
                    }
                )
                .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
                .onChange(of: search, perform: { viewModel.actual.filterProducts(filter: $0) })
            }
        }
    }

    private func productGroupsError(error: ResourceError<KotlinArray<GroupedProducts>>) -> some View {
        Text(error.userMessage())
    }

    private func getGroupNames(_ productGroups: [GroupedProducts]) -> [String] {
        var groupNames = productGroups.map { productGroup in
            productGroup.name
        }
        groupNames.insert(localize.productSearch_groups_all(), at: 0)
        return groupNames
    }
}
