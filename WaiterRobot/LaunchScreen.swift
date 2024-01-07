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
                    async let setup: () = setupApp()
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

    /// Setup of frameworks and all the other related stuff which is needed everywhere in the app
    private func setupApp() async {
        print("started app setup")
        var appVersion = readFromInfoPlist(withKey: "CFBundleShortVersionString")
        let versionSuffix = readFromInfoPlist(withKey: "VERSION_SUFFIX")
        if !versionSuffix.isEmpty {
            appVersion += "-\(versionSuffix)"
        }

        await CommonApp.shared.doInit(
            appVersion: appVersion,
            appBuild: Int32(readFromInfoPlist(withKey: "CFBundleVersion"))!,
            phoneModel: UIDevice.current.deviceType,
            os: OS.Ios(version: UIDevice.current.systemVersion),
            apiBaseUrl: readFromInfoPlist(withKey: "API_BASE")
        )

        KoinKt.doInitKoinIos()
        let logger = koin.logger(tag: "AppDelegate")
        logger.d { "initialized Koin" }

        KMMResourcesLocalizationKt.localizationBundle = Bundle(for: shared.L.self)
        logger.d { "initialized localization bundle" }
        print("finished app setup")
    }

    private func delay() async {
        print("started delay")
        try? await Task.sleep(seconds: minimumOnScreenTimeSeconds)
        print("finished delay")
    }

    private func readFromInfoPlist(withKey key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("Could not find key '\(key)' in info.plist file.")
        }

        return value
    }
}

#Preview {
    LaunchScreen()
}
