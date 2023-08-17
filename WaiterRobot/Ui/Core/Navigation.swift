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
                            if let icon = icon {
                                HStack {
                                    Image(systemName: icon)
                                        .fontWeight(.semibold)
                                }
                                .padding(.trailing, 4)
                            }

                            Text(title)
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Color("primaryColor"))
                }
            }
    }

    @MainActor
    func handleSideEffects<S, E, VM, OVM>(
        of vm: OVM, _ navigator: UIPilot<Screen>,
        handler: ((E) -> Bool)? = nil
    ) -> some View where S: ViewModelState, E: ViewModelEffect, VM: AbstractViewModel<S, E>, OVM: ObservableViewModel<S, E, VM> {
        onReceive(vm.sideEffect) { effect in
            debugPrint("Got Sideeffect \(effect)")

            switch effect {
            case let navEffect as NavOrViewModelEffectNavEffect<E>:
                navigator.navigate(navEffect.action)

            case let sideEffect as NavOrViewModelEffectVMEffect<E>:
                if handler?(sideEffect.effect) != true {
                    koin.logger(tag: "handleSideEffects").w { "Side effect \(sideEffect.effect) was not handled." }
                }
            default:
                koin.logger(tag: "handleSideEffects").w { "Unhandled effect type \(effect)." }
            }
        }
    }
}
