import SwiftUI

public extension Color {
    static var main: Color {
        Color(.main)
    }

    static var accent: Color {
        Color(.accent)
    }

    /// black in light mode, white in dark mode
    static var blackWhite: Color {
        Color(.blackWhite)
    }

    /// white in light mode, black in dark mode
    static var whiteBlack: Color {
        Color(.whiteBlack)
    }
}
