import SharedUI
import SwiftUI

struct TableView: View {
    let text: String
    let hasOrders: Bool
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blackWhite, lineWidth: 5)

                Text(text)
                    .font(.title)

                if hasOrders {
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()

                            Circle()
                                .foregroundColor(.accentColor)
                                .frame(width: 12)
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                }
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .foregroundColor(.blackWhite)
    }
}

#Preview {
    VStack {
        TableView(text: "1", hasOrders: false, onClick: {})
            .frame(maxWidth: 100)

        TableView(text: "2", hasOrders: true, onClick: {})
            .frame(maxWidth: 100)
    }
}
