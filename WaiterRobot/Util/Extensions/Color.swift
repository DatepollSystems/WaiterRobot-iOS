//
//  Color.swift
//  WaiterRobot
//
//  Created by Alexander Kauer on 10.07.24.
//

import SwiftUI

extension Color {
    static var lightGray: Color {
        Color(hex: "#D1D1D6")
    }

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    init?(hex: String?) {
        guard
            let hex = hex?.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        else {
            return nil
        }

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// Adjust color based on contrast
    func bestContrastColor(_ color1: Color, _ color2: Color, in env: EnvironmentValues) -> Color {
        let backgroundResolved = resolve(in: env)
        let color1Resolved = color1.resolve(in: env)
        let color2Resolved = color2.resolve(in: env)

        let contrast1 = Color.Resolved.contrastRatio(foreground: color1Resolved, background: backgroundResolved)
        let contrast2 = Color.Resolved.contrastRatio(foreground: color2Resolved, background: backgroundResolved)

        return contrast1 > contrast2 ? color1 : color2
    }
}

extension Color.Resolved {
    static func contrastRatio(foreground: Color.Resolved, background: Color.Resolved) -> Float {
        #if DEBUG
            if background.opacity != 1 {
                fatalError("Background can not be translucent")
            }
        #endif
        let lum1 = foreground.composite(on: background).luminance() // calculate the luminance when composed on top of background to account for alpha
        let lum2 = background.luminance()
        let lighter = max(lum1, lum2)
        let darker = min(lum1, lum2)
        return (lighter + 0.05) / (darker + 0.05)
    }

    func luminance() -> Float {
        0.2126 * linearRed + 0.7152 * linearGreen + 0.0722 * linearBlue
    }

    private func composite(on background: Color.Resolved) -> Color.Resolved {
        if opacity == 1 { return self }
        if opacity == 0 { return self }

        let alpha = opacity + background.opacity * (1 - opacity)

        let r = (red * opacity + background.red * background.opacity * (1 - opacity)) / alpha
        let g = (green * opacity + background.green * background.opacity * (1 - opacity)) / alpha
        let b = (blue * opacity + background.blue * background.opacity * (1 - opacity)) / alpha

        return Color.Resolved(red: r, green: g, blue: b, opacity: alpha)
    }
}
