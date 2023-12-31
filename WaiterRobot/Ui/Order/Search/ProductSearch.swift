import shared
import SwiftUI

struct ProductSearch: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: ObservableViewModel<OrderState, OrderEffect, OrderViewModel>

    @State private var search: String = ""
    @State private var selectedTab: Int = 0

    private let layout = [
        GridItem(.adaptive(minimum: 110)),
    ]

    var body: some View {
        NavigationView {
            if viewModel.state.productGroups.isEmpty {
                Text(localize.productSearch.noProductFound())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                VStack {
                    ProducSearchTabBarHeader(currentTab: $selectedTab, tabBarOptions: getGroupNames(viewModel.state.productGroups))

                    TabView(selection: $selectedTab) {
                        ProductSearchAllTab(
                            productGroups: viewModel.state.productGroups,
                            columns: layout,
                            onProductClick: {
                                viewModel.actual.addItem(product: $0, amount: 1)
                                dismiss()
                            }
                        )
                        .tag(0)
                        .padding()

                        ForEach(Array(viewModel.state.productGroups.enumerated()), id: \.element.id) { index, groupWithProducts in
                            ScrollView {
                                LazyVGrid(columns: layout, spacing: 0) {
                                    ProductSearchGroupList(
                                        products: groupWithProducts.products,
                                        onProductClick: {
                                            viewModel.actual.addItem(product: $0, amount: 1)
                                            dismiss()
                                        }
                                    )
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
                .onChange(of: search, perform: viewModel.actual.filterProducts)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(localize.dialog.cancel()) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }

    private func getGroupNames(_ productGroups: [ProductGroup]) -> [String] {
        var groupNames = productGroups.map { productGroup in
            productGroup.name
        }
        groupNames.insert(localize.productSearch.allGroups(), at: 0)
        return groupNames
    }
}
