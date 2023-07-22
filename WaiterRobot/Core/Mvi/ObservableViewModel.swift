/// Base on
/// - https://johnoreilly.dev/posts/kotlinmultiplatform-swift-combine_publisher-flow/
/// - https://proandroiddev.com/kotlin-multiplatform-mobile-sharing-the-ui-state-management-a67bd9a49882
/// - https://github.com/orbit-mvi/orbit-swift-gradle-plugin/blob/main/src/main/resources/stateObject.swift.mustache

import Combine
import Foundation
import shared

@MainActor
class ObservableViewModel<S: ViewModelState, E: ViewModelEffect, VM: AbstractViewModel<S, E>>: ObservableObject {
    @Published public private(set) var state: S
    public private(set) var sideEffect: AnyPublisher<NavOrViewModelEffect<E>, Never>

    public let actual: VM

    init(vm: VM) {
        actual = vm
        // This is save, as the constraint is required by the generics (S must be the state of the provided VM)
        state = actual.container.stateFlow.value as! S
        sideEffect = actual.container.sideEffectFlow.asPublisher() as AnyPublisher<NavOrViewModelEffect<E>, Never>

        (actual.container.stateFlow.asPublisher() as AnyPublisher<S, Never>)
            .receive(on: RunLoop.main)
            .assign(to: &$state)
    }

    deinit {
        actual.onCleared()
    }
}
