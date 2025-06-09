import shared
import SwiftUI
import WRCore

struct ProductSearch: View {
    let addItem: (_ product: Product, _ amount: Int32) -> Void

    @Environment(\.dismiss) private var dismiss

    @ObservedObject private var viewModel = ObservableProductListViewModel()

    @State private var search: String = ""
    @State private var selectedTab: Int = 0

    private let layout = [
        GridItem(.adaptive(minimum: 110)),
    ]

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
                productsGroupsList(productGroups: productGroups)
            }
        }
    }

    @ViewBuilder
    private func productsGroupsList(productGroups: [GroupedProducts]) -> some View {
        if productGroups.isEmpty {
            Text(localize.productSearch_noProductFound())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
        } else {
            VStack {
                ProducSearchTabBarHeader(currentTab: $selectedTab, tabBarOptions: getGroupNames(productGroups))

                TabView(selection: $selectedTab) {
                    ProductSearchAllTab(
                        productGroups: productGroups,
                        columns: layout,
                        onProductClick: {
                            addItem($0, 1)
                            dismiss()
                        }
                    )
                    .tag(0)
                    .padding()

                    let enumeratedProductGroups = Array(productGroups.enumerated())
                    ForEach(enumeratedProductGroups, id: \.element.id) { index, groupedProducts in
                        ScrollView {
                            LazyVGrid(columns: layout, spacing: 0) {
                                productGroup(groupedProducts: groupedProducts)
                                Spacer()
                            }
                            .padding()
                        }
                        .tag(index + 1)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: search, perform: { viewModel.actual.filterProducts(filter: $0) })
        }
    }

    @ViewBuilder
    private func productGroup(groupedProducts: GroupedProducts) -> some View {
        ProductSearchGroupList(
            products: groupedProducts.products,
            backgroundColor: Color(hex: groupedProducts.color),
            onProductClick: {
                addItem($0, 1)
                dismiss()
            }
        )
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
