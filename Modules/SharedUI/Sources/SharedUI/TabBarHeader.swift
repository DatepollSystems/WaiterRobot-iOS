import SwiftUI

public struct TabBarHeader: View {
    @Namespace var namespace
    @Binding var currentTab: Int
    var tabBarOptions: [String]

    public init(currentTab: Binding<Int>, tabBarOptions: [String]) {
        _currentTab = currentTab
        self.tabBarOptions = tabBarOptions
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(
                        Array(zip(tabBarOptions.indices, tabBarOptions)),
                        id: \.0
                    ) { index, name in
                        Button {
                            currentTab = index
                        } label: {
                            VStack {
                                Spacer()
                                Text(name)
                                    .padding(.horizontal)
                                if currentTab == index {
                                    Color.blue
                                        .frame(height: 2)
                                        .matchedGeometryEffect(
                                            id: "underline",
                                            in: namespace,
                                            properties: .frame
                                        )
                                } else {
                                    Color.clear.frame(height: 2)
                                }
                            }
                            .animation(.spring(), value: currentTab)
                        }
                        .buttonStyle(.plain)
                        .padding(0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding(.horizontal)
            .padding(.bottom, 7)
            Divider()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var currentTab = 3
    TabBarHeader(
        currentTab: $currentTab,
        tabBarOptions: ["All", "Food", "Drinks", "more", "One more"]
    )
}
