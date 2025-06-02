import shared
import SwiftUI
import WRCore

struct ProductSearch: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: ObservableProductListViewModel
    let addItem: (_ product: Product, _ amount: Int32) -> Void

    @State private var search: String = ""
    @State private var selectedTab: Int = 0

    private let layout = [
        GridItem(.adaptive(minimum: 110)),
    ]

    var body: some View {
        NavigationView {
            switch onEnum(of: viewModel.state.productGroups) {
            case .loading:
                ProgressView()
            case let .error(resource):
                productGroupsError(error: resource)
            case let .success(resource):
                if let productGroups = resource.data {
                    productsGroupsList(productGroups: productGroups)
                }
            }
        }.observeState(of: viewModel)
    }

    @ViewBuilder
    private func productsGroupsList(productGroups: KotlinArray<GroupedProducts>) -> some View {
        if let productGroups = Array(productGroups), !productGroups.isEmpty {
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
                    ForEach(enumeratedProductGroups, id: \.element.id) { index, _ in
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localize.dialog_cancel()) {
                        dismiss()
                    }
                }
            }
        } else {
            Text(localize.productSearch_noProductFound())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
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
