import Foundation
import shared

var koin: IosKoinComponent { IosKoinComponent.shared }

// Shortcut for localization
@available(*, deprecated, renamed: "L")
var localizeString: shared.L.Companion { shared.L.Companion.shared }

var localize: shared.L.Companion { shared.L.Companion.shared }
