import shared
import SwiftUI
import WRCore

struct SwitchThemeView: View {
    @State private var selectedTheme: AppTheme
    private var onChange: (AppTheme) -> Void

    init(initial: AppTheme, onChange: @escaping (AppTheme) -> Void) {
        _selectedTheme = SwiftUI.State(initialValue: initial)
        self.onChange = onChange
    }

    var body: some View {
        Picker(localize.settings.darkMode.title(), selection: $selectedTheme) {
            ForEach(AppTheme.companion.valueList(), id: \.name) { theme in
                Text(theme.settingsText()).tag(theme)
            }
        }
        .onChange(of: selectedTheme, perform: onChange)
    }
}

#Preview {
    SwitchThemeView(initial: AppTheme.system, onChange: { _ in })
}
