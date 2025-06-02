import shared
import SwiftUI

struct ViewStateOverlayView<Content: View>: View {
    let state: Skie.Shared.ViewState.__Sealed
    let content: () -> Content

    init(state: ViewState, @ViewBuilder content: @escaping () -> Content) {
        self.state = onEnum(of: state)
        self.content = content
    }

    var body: some View {
        ZStack {
            LoadingOverlayView(isLoading: isLoading) {
                VStack(alignment: .leading) {
                    content()
                }
            }
        }
        .alert(item: Binding(
            get: { dialogState },
            set: { _ in dialogState?.onDismiss() }
        )) { dialog in
            Alert(dialog)
        }
    }

    private var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }

    private var dialogState: DialogState? {
        if case let .error(error) = state {
            return error.dialog
        }
        return nil
    }
}

extension DialogState: Identifiable {}
