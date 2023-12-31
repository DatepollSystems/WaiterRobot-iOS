import Foundation
import shared
import SwiftUI
import UIPilot

extension UIPilot<Screen> {
    func navigate(_ navAction: NavAction) {
        koin.logger(tag: "Navigation").d { "Handle navigation: \(navAction.description)" }
        switch navAction {
        case is NavAction.Pop:
            pop()
        case let nav as NavAction.Push:
            push(nav.screen)
        case let nav as NavAction.PopUpTo:
            popTo(nav.screen, inclusive: nav.inclusive)
        case let nav as NavAction.PopUpAndPush:
            popTo(nav.popUpTo, inclusive: nav.inclusive)
            push(nav.screen)
        default:
            koin.logger(tag: "Navigation").e {
                "No nav action for nav effect \(navAction.self.description)"
            }
        }
    }
}

extension View {
    func customBackNavigation(
        title: String = localize.navigation.back(),
        icon: String? = "chevron.left",
        action: @escaping () -> Void
    ) -> some View {
        navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: action) {
                        HStack(spacing: 0) {
                            if let icon {
                                HStack {
                                    Image(systemName: icon)
                                    // .fontWeight(.semibold) // TODO enable when dropped iOS15
                                }
                                .padding(.trailing, 4)
                            }

                            Text(title)
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.main)
                }
            }
    }

    @MainActor
    func handleSideEffects<State, Effect>(
        of viewModel: some ObservableViewModel<State, Effect, some AbstractViewModel<State, Effect>>, _ navigator: UIPilot<Screen>,
        handler: ((Effect) -> Bool)? = nil
    ) -> some View where State: ViewModelState, Effect: ViewModelEffect {
        onReceive(viewModel.sideEffect) { effect in
            debugPrint("Got Sideeffect \(effect)")

            switch effect {
            case let navEffect as NavOrViewModelEffectNavEffect<Effect>:
                navigator.navigate(navEffect.action)

            case let sideEffect as NavOrViewModelEffectVMEffect<Effect>:
                if handler?(sideEffect.effect) != true {
                    koin.logger(tag: "handleSideEffects").w { "Side effect \(sideEffect.effect) was not handled." }
                }
            default:
                koin.logger(tag: "handleSideEffects").w { "Unhandled effect type \(effect)." }
            }
        }
    }
}
