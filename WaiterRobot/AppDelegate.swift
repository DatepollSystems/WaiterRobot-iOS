import shared
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Init CommonApp right at the start as e.g. koin might depend on some properties of it
        var appVersion = readFromInfoPlist(withKey: "CFBundleShortVersionString")
        let versionSuffix = readFromInfoPlist(withKey: "VERSION_SUFFIX")
        if !versionSuffix.isEmpty {
            appVersion += "-\(versionSuffix)"
        }

        CommonApp.shared.doInit(
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

        return true
    }

    private func readFromInfoPlist(withKey key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("Could not find key '\(key)' in info.plist file.")
        }

        return value
    }
}
