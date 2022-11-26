import SwiftUI
import shared

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    KoinKt.doInitKoinIos()
    let logger = koin.logger(tag: "AppDelegate")
    logger.d { "initialized Koin" }
    
    logger.d { "Try to init localization" }
    KMMResourcesLocalizationKt.localizationBundle = Bundle(for: L.self)
    logger.d { "init localization finished" }
    
    return true
  }
}
