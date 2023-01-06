import SwiftUI

extension View {
  func floatingActionButton(icon: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
    toolbar {
      ToolbarItemGroup(placement: .bottomBar) {
        Spacer()
        Button {
          action()
        } label: {
          Image(systemName: icon)
            .font(.system(.title))
            .padding()
            .tint(.white)
        }
        .background(.blue)
        .mask(Circle())
        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
        .disabled(disabled)
      }
    }
  }
}
