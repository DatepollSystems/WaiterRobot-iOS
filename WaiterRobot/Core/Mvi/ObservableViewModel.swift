/// Base on
/// - https://johnoreilly.dev/posts/kotlinmultiplatform-swift-combine_publisher-flow/
/// - https://proandroiddev.com/kotlin-multiplatform-mobile-sharing-the-ui-state-management-a67bd9a49882
/// - https://github.com/orbit-mvi/orbit-swift-gradle-plugin/blob/main/src/main/resources/stateObject.swift.mustache

import Combine
import Foundation
import shared

@MainActor
class ObservableViewModel<State: ViewModelState, Effect: ViewModelEffect, ViewModel: AbstractViewModel<State, Effect>>: ObservableObject {
    @Published
    public private(set) var state: State

    public private(set) var sideEffect: AnyPublisher<NavOrViewModelEffect<Effect>, Never>

    public let actual: ViewModel

    init(viewModel: ViewModel) {
        actual = viewModel
        // This is save, as the constraint is required by the generics (S must be the state of the provided ViewModel)
        state = actual.container.stateFlow.value as! State
        sideEffect = actual.container.sideEffectFlow.asPublisher() as AnyPublisher<NavOrViewModelEffect<Effect>, Never>

        (actual.container.stateFlow.asPublisher() as AnyPublisher<State, Never>)
            .receive(on: RunLoop.main)
            .assign(to: &$state)
    }

    deinit {
        actual.onCleared()
    }
}
