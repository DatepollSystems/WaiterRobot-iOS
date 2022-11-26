import SwiftUI

struct Table: View {
  let text: String
  var size: CGFloat = 80
  let onClick: () -> Void
  
  var body: some View {
    Button(action: onClick) {
      Text(text)
        .font(.title)
        .frame(width: size, height: size, alignment: .center)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color("textColor"), lineWidth: 5)
        )
        .foregroundColor(Color("textColor"))
    }
  }
}

struct Table_Previews: PreviewProvider {
  static var previews: some View {
    Table(text: "1", onClick: {})
  }
}
