import shared
import SwiftUI

struct OrderListItem: View {
    let name: String
    let amount: Int32
    let note: String?
    let addOne: () -> Void
    let removeOne: () -> Void
    let removeAll: () -> Void
    let onSaveNote: (String?) -> Void

    @State private var editNote: Bool = false
    @State private var editedNote: String = ""

    var body: some View {
        Button {
            addOne()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(amount) x")
                    Spacer()
                    Text(name)

                    Button {
                        editNote = true
                        editedNote = note ?? ""
                    } label: {
                        Image(systemName: "pencil")
                            .imageScale(.large)
                    }.foregroundColor(.accentColor)
                }

                if let note {
                    Text(note)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .foregroundColor(.blackWhite)
        }
        // TODO: make only half screen when ios 15 is dropped
        .sheet(isPresented: $editNote) {
            NavigationView {
                VStack {
                    TextEditorWithPlaceholder(
                        text: $editedNote,
                        lable: localize.order.addNoteDialog.inputLabel(),
                        placeHolder: localize.order.addNoteDialog.inputPlaceholder(),
                        editorHeight: 110,
                        maxLength: 120
                    )

                    HStack {
                        Button(localize.dialog.cancel(), role: .cancel) {
                            editNote = false
                        }
                        Spacer()
                        Button(localize.dialog.clear()) {
                            onSaveNote(nil)
                            editNote = false
                        }
                        Spacer()
                        Button(localize.dialog.save()) {
                            onSaveNote(editedNote)
                            editNote = false
                        }
                    }
                    .padding(.top)

                    Spacer()
                }
                .padding()
                .navigationTitle(localize.order.addNoteDialog.title(value0: name))
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
            HStack {
                Button(action: {
                    removeOne()
                }, label: {
                    Image(systemName: "minus")
                })
                .tint(.gray)

                Button(action: {
                    withAnimation(.spring()) {
                        removeAll()
                    }
                }, label: {
                    Image(systemName: "trash")
                })
                .tint(.red)
            }
        })
        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
            Button(action: {
                addOne()
            }, label: {
                Image(systemName: "plus")
            })
            .tint(.green)
        })
    }
}

#Preview {
    List {
        OrderListItem(
            name: "Beer",
            amount: 5,
            note: nil,
            addOne: {},
            removeOne: {},
            removeAll: {},
            onSaveNote: { _ in }
        )
        OrderListItem(
            name: "Wine",
            amount: 20,
            note: "1x without Tomatoe",
            addOne: {},
            removeOne: {},
            removeAll: {},
            onSaveNote: { _ in }
        )
    }
}
