/// Base on
/// - https://johnoreilly.dev/posts/kotlinmultiplatform-swift-combine_publisher-flow/
/// - https://proandroiddev.com/kotlin-multiplatform-mobile-sharing-the-ui-state-management-a67bd9a49882
/// - https://github.com/orbit-mvi/orbit-swift-gradle-plugin/blob/main/src/main/resources/stateObject.swift.mustache

import Foundation
import shared

@MainActor
class ObservableViewModel<S: ViewModelState, E: ViewModelEffect, VM: AbstractViewModel<S, E>>: ObservableObject {
    @Published public private(set) var state: S

    public let actual: VM

    private var task: Task<Void, Error>? = nil

    init(vm: VM) {
        actual = vm
        // This is save, as the constraint is required by the generics (S must be the state of the provided VM)
        state = actual.container.stateFlow.value as! S

        activate()
    }

    deinit {
        actual.onCleared()
        task?.cancel()
    }

    @MainActor
    private func activate() {
        guard task == nil else { return }
        task = Task {
            for await state in actual.container.stateFlow {
                self.state = state as! S
            }
        }
    }
}

class TableListObservableViewModel: ObservableViewModel<TableListState, TableListEffect, TableListViewModel> {
    init() {
        super.init(vm: koin.tableListVM())
    }
}
