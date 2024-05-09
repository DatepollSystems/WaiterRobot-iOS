import SwiftUI

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    let lable: String
    let placeHolder: String
    let editorHeight: CGFloat
    let maxLength: Int?

    var body: some View {
        VStack {
            Text(lable)

            TextEditor(text: $text)
                .border(.gray)
                .frame(maxHeight: editorHeight)
                .overlay(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeHolder)
                            .foregroundColor(.gray.opacity(0.3))
                            .padding(.leading, 5)
                            .padding(.top, 9)
                    }
                }
                .onChange(of: text) { _ in
                    guard let maxLength else { return }
                    if text.count > maxLength {
                        text = String(text.prefix(maxLength))
                    }
                }

            if let maxLength {
                Text("\(text.count)/\(maxLength)")
            }
        }
    }
}

#Preview {
    TextEditorWithPlaceholder(text: .constant(""), lable: "Lable", placeHolder: "Some placeholder", editorHeight: 150, maxLength: 150)
}
