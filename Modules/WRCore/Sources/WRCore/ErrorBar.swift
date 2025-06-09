import shared
import SharedUI
import SwiftUI

public struct ErrorBar: View {
    let message: StringDesc
    let initialLines: Int
    let retryAction: (() -> Void)?

    @State private var expanded = false

    public init(message: StringDesc, initialLines: Int = 2, retryAction: (() -> Void)? = nil) {
        self.message = message
        self.initialLines = initialLines
        self.retryAction = retryAction
    }

    public var body: some View {
        HStack(alignment: .center) {
            Text(message())
                .lineLimit(expanded ? nil : initialLines)
                .multilineTextAlignment(.leading)
                // .foregroundColor(Color.onErrorContainer)
                .frame(maxWidth: .infinity, alignment: .leading)

            if retryAction != nil {
                Spacer().frame(width: 16)
                Button(action: {
                    retryAction?()
                }) {
                    Text(localize.exceptions_retry())
                        .bold()
                        .multilineTextAlignment(.center)
                        .lineLimit(expanded ? nil : initialLines)
                }
                // .foregroundColor(Color.onErrorContainer)
            }
        }
        .padding(.leading, 16)
        .padding(.top, 8)
        .padding(.trailing, retryAction == nil ? 16 : 8)
        .padding(.bottom, 8)
        // .background(Color.errorContainer)
        .onTapGesture {
            withAnimation {
                expanded.toggle()
            }
        }
        .animation(.default, value: expanded)
    }
}
