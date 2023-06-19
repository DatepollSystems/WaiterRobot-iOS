import SwiftUI

struct Table: View {
  let text: String
  let onClick: () -> Void
  
  var body: some View {
    Button(action: onClick) {
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color("textColor"), lineWidth: 5)
        
        Text(text)
          .font(.title)
      }
    }
    .aspectRatio(1.0, contentMode: .fit)
    .foregroundColor(Color("textColor"))
  }
}

struct Table_Previews: PreviewProvider {
  static var previews: some View {
    Table(text: "1", onClick: {})
  }
}
