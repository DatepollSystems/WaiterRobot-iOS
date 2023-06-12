import Foundation
import shared

var koin: IosKoinComponent {
  get { IosKoinComponent.shared }
}

// Shortcut for localization
@available(*, deprecated, renamed: "L")
var S: shared.L.Companion {
  get { shared.L.Companion.shared }
}

var L: shared.L.Companion {
  get { shared.L.Companion.shared }
}
