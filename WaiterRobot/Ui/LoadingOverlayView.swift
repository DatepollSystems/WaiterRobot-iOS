import SwiftUI

struct LoadingOverlayView<Content: View>: View {
    let isLoading: Bool
    let content: () -> Content

    init(isLoading: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.isLoading = isLoading
        self.content = content
    }

    var body: some View {
        ZStack {
            content()
                .opacity(isLoading ? 0.5 : 1.0)

            if isLoading {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
}
