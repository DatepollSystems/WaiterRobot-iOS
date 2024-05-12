import Foundation
import shared
import SwiftUI
import UIPilot

extension UIPilot<Screen> {
    func navigate(_ navAction: NavAction) {
        koin.logger(tag: "Navigation").d { "Handle navigation: \(navAction.description)" }

        switch onEnum(of: navAction) {
        case .pop:
            pop()

        case let .push(nav):
            push(nav.screen)

        case let .popUpTo(nav):
            popTo(nav.screen, inclusive: nav.inclusive)

        case let .popUpAndPush(nav):
            popTo(nav.popUpTo, inclusive: nav.inclusive)
            push(nav.screen)

        case let .replaceRoot(nav):
            guard let topmost = topmostScreen else { return }
            popTo(topmost, inclusive: true)
            push(nav.screen)
        }
    }

    var topmostScreen: Screen? {
        stack.first
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
                                    // .fontWeight(.semibold) // TODO: enable when dropped iOS15
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
    func handleSideEffects<S, E>(
        of viewModel: some ObservableViewModel<S, E, some AbstractViewModel<S, E>>,
        _ navigator: UIPilot<Screen>,
        handler: ((E) -> Bool)? = nil
    ) -> some View where S: ViewModelState, E: ViewModelEffect {
        handleSideEffects2(of: viewModel.actual, navigator, handler: handler)
    }

    @MainActor
    func handleSideEffects2<E>(
        of viewModel: some AbstractViewModel<some ViewModelState, E>,
        _ navigator: UIPilot<Screen>,
        handler: ((E) -> Bool)? = nil
    ) -> some View where E: ViewModelEffect {
        task {
            let logger = koin.logger(tag: "handleSideEffects")
            for await sideEffect in viewModel.container.sideEffectFlow {
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
    func observeState<S>(
        of viewModel: some AbstractViewModel<S, some ViewModelEffect>,
        stateBinding: Binding<S>
    ) -> some View where S: ViewModelState {
        task {
            let logger = koin.logger(tag: "ObservableViewModel")
            for await state in viewModel.container.stateFlow {
                logger.d { "New state: \(state)" }
                stateBinding.wrappedValue = state as! S
            }
        }
    }
}
