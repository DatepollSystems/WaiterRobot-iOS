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
                                    // .fontWeight(.semibold) // TODO enable when dropped iOS15
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
        of vm: OVM,
        _ navigator: UIPilot<Screen>,
        handler: ((E) -> Bool)? = nil
    ) -> some View where S: ViewModelState, E: ViewModelEffect, VM: AbstractViewModel<S, E>, OVM: ObservableViewModel<S, E, VM> {
        handleSideEffects2(of: vm.actual, navigator, handler: handler)
    }

    @MainActor
    func handleSideEffects2<S, E, VM>(
        of vm: VM,
        _ navigator: UIPilot<Screen>,
        handler: ((E) -> Bool)? = nil
    ) -> some View where S: ViewModelState, E: ViewModelEffect, VM: AbstractViewModel<S, E> {
        task {
            let logger = koin.logger(tag: "handleSideEffects")
            for await sideEffect in vm.container.sideEffectFlow {
                logger.d { "Got sideEffect: \(sideEffect)" }
                switch onEnum(of: sideEffect as! NavOrViewModelEffect<E>) {
                case let .navEffect(navEffect):
                    navigator.navigate(navEffect.action)
                case let .vMEffect(effect):
                    if handler?(effect.effect) != true {
                        logger.w { "Side effect \(effect.effect) was not handled." }
                    }
                }
            }
        }
    }

    @MainActor
    func observeState<S, E, VM>(
        of vm: VM,
        stateBinding: Binding<S>
    ) -> some View where S: ViewModelState, E: ViewModelEffect, VM: AbstractViewModel<S, E> {
        task {
            let logger = koin.logger(tag: "ObservableViewModel")
            for await state in vm.container.stateFlow {
                logger.d { "New state: \(state)" }
                stateBinding.wrappedValue = state as! S
            }
        }
    }
}
