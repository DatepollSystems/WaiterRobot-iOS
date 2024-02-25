//
//  WRBorderedProminentButtonStyle.swift
//  WaiterRobot
//
//  Created by Alexander Kauer on 25.02.24.
//

import SwiftUI

struct WRBorderedProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? .white : .white.opacity(0.8))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .ifCondition(isEnabled) { view in
                        view.foregroundStyle(configuration.isPressed ? .main.opacity(0.6) : .main)
                    }
                    .ifCondition(!isEnabled) { view in
                        view.foregroundStyle(.gray)
                    }
            )
    }
}

extension ButtonStyle where Self == WRBorderedProminentButtonStyle {
    static var wrBorderedProminent: WRBorderedProminentButtonStyle {
        WRBorderedProminentButtonStyle()
    }
}
