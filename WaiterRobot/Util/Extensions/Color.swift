//
//  Color.swift
//  WaiterRobot
//
//  Created by Alexander Kauer on 10.07.24.
//

import SwiftUI

extension Color {
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

    // Adjust color based on contrast
    // TODO: this does not respect opacity
    func getContentColor(lightColorScheme: Color, darkColorScheme: Color) -> Color {
        let lightContrast = lightColorScheme.contrastRatio(with: self)
        let darkContrast = darkColorScheme.contrastRatio(with: self)

        return lightContrast > darkContrast ? lightColorScheme : darkColorScheme
    }

    // Calculate contrast ratio
    private func contrastRatio(with other: Color) -> Double {
        let l1 = luminance()
        let l2 = other.luminance()
        return (max(l1, l2) + 0.05) / (min(l1, l2) + 0.05)
    }

    // Calculate luminance
    private func luminance() -> Double {
        let components = cgColor?.components ?? [0, 0, 0, 1]
        let red = Color.convertSRGBToLinear(components[0])
        let green = Color.convertSRGBToLinear(components[1])
        let blue = Color.convertSRGBToLinear(components[2])

        return 0.2126 * red + 0.7152 * green + 0.0722 * blue
    }

    private static func convertSRGBToLinear(_ component: CGFloat) -> Double {
        component <= 0.03928 ? Double(component) / 12.92 : pow((Double(component) + 0.055) / 1.055, 2.4)
    }
}
