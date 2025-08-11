import SharedUI
import SwiftUI

struct TableView: View {
    @Environment(\.self) 
    private var env

    let text: String
    let hasOrders: Bool
    let backgroundColor: Color
    let onClick: () -> Void

    init(text: String, hasOrders: Bool, backgroundColor: Color?, onClick: @escaping () -> Void) {
        self.text = text
        self.hasOrders = hasOrders
        self.backgroundColor = backgroundColor ?? .lightGray
        self.onClick = onClick
    }

    var body: some View {
        Button(action: onClick) {
            ZStack(alignment: .topTrailing) {
                Text(text)
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if hasOrders {
                    Circle()
                        .foregroundColor(backgroundColor.bestContrastColor(Color(.darkRed), Color(.lightRed), in: env))
                        .frame(width: 12, height: 12)
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                }
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(backgroundColor)
        }
        .foregroundStyle(backgroundColor.bestContrastColor(.white, .black, in: env))
    }
}

#Preview {
    VStack {
        TableView(text: "1", hasOrders: true, backgroundColor: .blackWhite) {}
            .frame(maxWidth: 100)

        TableView(text: "1", hasOrders: false, backgroundColor: .gray) {}
            .frame(maxWidth: 100)

        TableView(text: "1", hasOrders: true, backgroundColor: .green) {}
            .frame(maxWidth: 100)

        TableView(text: "2", hasOrders: true, backgroundColor: nil) {}
            .frame(maxWidth: 100)
    }
}
