import SwiftUI
import shared

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    
    // Init CommonApp right at the start as e.g. koin might depend on some properties of it
    CommonApp.shared.doInit(
      appVersion: readFromInfoPlist(withKey: "CFBundleShortVersionString")!,
      appBuild: Int32(readFromInfoPlist(withKey: "CFBundleVersion")!)!,
      phoneModel: UIDevice.current.deviceType,
      os: OS.Ios(version: UIDevice.current.systemVersion),
      apiBaseUrl: "https://my.kellner.team/"
    )
    
    KoinKt.doInitKoinIos()
    let logger = koin.logger(tag: "AppDelegate")
    logger.d { "initialized Koin" }
    
    KMMResourcesLocalizationKt.localizationBundle = Bundle(for: L.self)
    logger.d { "initialized localization bundle" }
    
    return true
  }
  
  private func readFromInfoPlist(withKey key: String) -> String? {
    Bundle.main.infoDictionary?[key] as? String
  }
}
