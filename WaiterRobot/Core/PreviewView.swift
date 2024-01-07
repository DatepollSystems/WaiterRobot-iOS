import shared
import SwiftUI
import UIPilot

#if DEBUG
    /// Helper view which sets up everything needed for previewing content
    struct PreviewView<Content: View>: View {
        @StateObject
        private var navigator = UIPilot<Screen>(initial: Screen.RootScreen.shared, debug: true)

        private let withUIPilot: Bool

        @ViewBuilder
        private let content: Content

        init(withUIPilot: Bool = true, @ViewBuilder content: () -> Content) {
            print("preview setup")
            WaiterRobotApp.setup()

            self.withUIPilot = withUIPilot
            self.content = content()
            print("preview done")
        }

        var body: some View {
            ZStack {
                if withUIPilot {
                    UIPilotHost(navigator) { _ in
                        content
                    }
                } else {
                    content
                }
            }
        }
    }
#endif
