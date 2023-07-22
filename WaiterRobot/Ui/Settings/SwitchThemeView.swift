import shared
import SwiftUI

struct SwitchThemeView: View {
    @State private var selectedTheme: AppTheme
    private var onChange: (AppTheme) -> Void

    init(initial: AppTheme, onChange: @escaping (AppTheme) -> Void) {
        _selectedTheme = SwiftUI.State(initialValue: initial)
        self.onChange = onChange
    }

    var body: some View {
        Picker(S.settings.darkMode.title(), selection: $selectedTheme) {
            ForEach(AppTheme.companion.valueList(), id: \.name) { theme in
                Text(theme.settingsText()).tag(theme)
            }
        }
        .onChange(of: selectedTheme, perform: onChange)
    }
}

struct SwitchThemeView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchThemeView(initial: AppTheme.system, onChange: { _ in })
    }
}
