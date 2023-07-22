import SwiftUI

struct SettingsItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 25)
                    .padding(.trailing)

                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding([.bottom, .top], 1)
    }
}

struct SettingsItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SettingsItem(
                icon: "rectangle.portrait.and.arrow.right",
                title: "Logout",
                subtitle: "Logout from this organisation",
                action: {}
            )
            SettingsItem(
                icon: "person.3",
                title: "Switch event",
                subtitle: "My Organisation / The Event",
                action: {}
            )
        }
    }
}
