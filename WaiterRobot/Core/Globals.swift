import Foundation
import shared

var koin: IosKoinComponent {
  get { IosKoinComponent.shared }
}

// Shortcut for localization
var S: L.Companion {
  get { L.Companion.shared }
}
