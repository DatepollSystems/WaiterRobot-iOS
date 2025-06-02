import shared
import SwiftUI

public extension Alert {
    init(_ dialog: DialogState) {
        if let secondaryButton = dialog.secondaryButton {
            self.init(
                title: Text(dialog.title.localized()),
                message: Text(dialog.text.localized()),
                primaryButton: .default(Text(dialog.primaryButton.text.localized()), action: dialog.primaryButton.action),
                secondaryButton: .cancel(Text(secondaryButton.text.localized()), action: secondaryButton.action)
            )
        } else {
            self.init(
                title: Text(dialog.title.localized()),
                message: Text(dialog.text.localized()),
                dismissButton: .default(Text(dialog.primaryButton.text.localized()), action: dialog.primaryButton.action)
            )
        }
    }
}
