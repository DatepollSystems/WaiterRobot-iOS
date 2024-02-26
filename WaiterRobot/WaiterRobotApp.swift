import shared
import SwiftUI
import UIPilot

@main
struct WaiterRobotApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
        }
    }

    /// Setup of frameworks and all the other related stuff which is needed everywhere in the app
    static func setup() {
        print("started app setup")
        var appVersion = readFromInfoPlist(withKey: "CFBundleShortVersionString")
        let versionSuffix = readFromInfoPlist(withKey: "VERSION_SUFFIX")
        if !versionSuffix.isEmpty {
            appVersion += "-\(versionSuffix)"
        }

        CommonApp.shared.doInit(
            appVersion: appVersion,
            appBuild: Int32(readFromInfoPlist(withKey: "CFBundleVersion"))!,
            phoneModel: UIDevice.current.model,
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

    private static func readFromInfoPlist(withKey key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("Could not find key '\(key)' in info.plist file.")
        }

        return value
    }
}
