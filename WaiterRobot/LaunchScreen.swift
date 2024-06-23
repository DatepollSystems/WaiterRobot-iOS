import Foundation
import shared
import SharedUI
import SwiftUI
import WRCore

struct LaunchScreen: View {
    private let minimumOnScreenTimeSeconds = 3.0
    private let device = UIDevice.current.userInterfaceIdiom

    @State private var startupFinished = false
    @State private var isVisible = false

    var body: some View {
        ZStack {
            VStack {
                Image.logoRounded
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(maxWidth: 300)
            }
            .padding()

            if startupFinished {
                MainView()
            }
        }
        .onAppear {
            // This is needed otherwise previews will crash randomly
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                Task {
                    async let setup: () = WRCore.setup()
                    async let delay: () = delay()

                    await setup
                    await delay

                    startupFinished = true
                }
            }
        }
        .animation(.spring, value: startupFinished)
    }

    private func delay() async {
        print("started delay")
        try? await Task.sleep(seconds: minimumOnScreenTimeSeconds)
        print("finished delay")
    }
}

#Preview {
    PreviewView {
        LaunchScreen()
    }
}
