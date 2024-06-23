import SwiftUI

public enum WrFont {
    case h1
    case h2
    case h3
    case h4
    case body
    case caption1
    case caption2

    var baseSize: CGFloat {
        switch self {
        case .h1:
            56
        case .h2:
            48
        case .h3:
            32
        case .h4:
            24
        case .body:
            16
        case .caption1:
            14
        case .caption2:
            12
        }
    }
}

private struct WrTextStyle: ViewModifier {
    let fontStyle: WrFont

    @ScaledMetric
    var fontSize: CGFloat

    var font: Font {
        .system(size: fontSize)
    }

    init(fontStyle: WrFont) {
        self.fontStyle = fontStyle
        _fontSize = ScaledMetric(wrappedValue: fontStyle.baseSize)
    }

    func body(content: Content) -> some View {
        content
            .font(font)
    }
}

public extension View {
    func textStyle(_ font: WrFont) -> some View {
        modifier(WrTextStyle(fontStyle: font))
    }
}

#Preview {
    ScrollView {
        VStack {
            Text("h1")
                .textStyle(.h1)

            Text("h2")
                .textStyle(.h2)

            Text("h3")
                .textStyle(.h3)

            Text("h4")
                .textStyle(.h4)

            Text("body")
                .textStyle(.body)

            Text("caption1")
                .textStyle(.caption1)

            Text("caption2")
                .textStyle(.caption2)
        }
    }
}
