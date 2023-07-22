import Foundation
import shared

var koin: IosKoinComponent { IosKoinComponent.shared }

// Shortcut for localization
@available(*, deprecated, renamed: "L")
var S: shared.L.Companion { shared.L.Companion.shared }

var L: shared.L.Companion { shared.L.Companion.shared }
