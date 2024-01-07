import Foundation
import shared
import SwiftUI

struct LaunchScreen: View {
    private let minimumOnScreenTimeSeconds = 3.0
    private let device = UIDevice.current.userInterfaceIdiom

    @State private var startupFinished = false

    var body: some View {
        VStack {
            if case .phone = device {
                VStack {
                    Spacer()

                    Image(.launch)
                        .resizable()
                        .scaledToFit()
                }
                .padding(.horizontal, -2)
                .ignoresSafeArea()
            } else {
                ZStack {
                    Image(.logoRounded)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .padding()

                    VStack {
                        Spacer()

                        ProgressView()
                            .padding()
                            .padding(.bottom)
                    }
                }
            }
        }
        .onAppear {
            // This is needed otherwise previews will crash randomly
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                Task {
                    async let setup: () = WaiterRobotApp.setup()
                    async let delay: () = delay()

                    await setup
                    await delay

                    startupFinished = true
                }
            }
        }
        .fullScreenCover(isPresented: $startupFinished) {
            MainView()
        }
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
