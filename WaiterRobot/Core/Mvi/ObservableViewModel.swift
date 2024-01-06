/// Base on
/// - https://johnoreilly.dev/posts/kotlinmultiplatform-swift-combine_publisher-flow/
/// - https://proandroiddev.com/kotlin-multiplatform-mobile-sharing-the-ui-state-management-a67bd9a49882
/// - https://github.com/orbit-mvi/orbit-swift-gradle-plugin/blob/main/src/main/resources/stateObject.swift.mustache

import Foundation
import shared

@MainActor
class ObservableViewModel<State: ViewModelState, Effect: ViewModelEffect, ViewModel: AbstractViewModel<State, Effect>>: ObservableObject {
    @Published public private(set) var state: State

    public let actual: ViewModel

    private var task: Task<Void, Error>? = nil

    init(viewModel: ViewModel) {
        actual = viewModel
        // This is save, as the constraint is required by the generics (S must be the state of the provided VM)
        state = actual.container.stateFlow.value as! State

        activate()
    }

    deinit {
        actual.onCleared()
        task?.cancel()
    }

    @MainActor
    private func activate() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let stateFlow = self?.actual.container.stateFlow else { return }

            for await state in stateFlow {
                self?.state = state as! State
            }
        }
    }
}

class TableListObservableViewModel: ObservableViewModel<TableListState, TableListEffect, TableListViewModel> {
    init() {
        super.init(viewModel: koin.tableListVM())
    }
}

class TableDetailObservableViewModel: ObservableViewModel<TableDetailState, TableDetailEffect, TableDetailViewModel> {
    init(table: Table) {
        super.init(viewModel: koin.tableDetailVM(table: table))
    }
}

class RootObservableViewModel: ObservableViewModel<RootState, RootEffect, RootViewModel> {
    init() {
        super.init(viewModel: koin.rootVM())
    }
}

class BillingObservableViewModel: ObservableViewModel<BillingState, BillingEffect, BillingViewModel> {
    init(table: Table) {
        super.init(viewModel: koin.billingVM(table: table))
    }
}

class OrderObservableViewModel: ObservableViewModel<OrderState, OrderEffect, OrderViewModel> {
    init(table: Table, initialItemId: KotlinLong?) {
        super.init(viewModel: koin.orderVM(table: table, initialItemId: initialItemId))
    }
}

class LoginScannerObservableViewModel: ObservableViewModel<LoginScannerState, LoginScannerEffect, LoginScannerViewModel> {
    init() {
        super.init(viewModel: koin.loginScannerVM())
    }
}

class SettingsObservableViewModel: ObservableViewModel<SettingsState, SettingsEffect, SettingsViewModel> {
    init() {
        super.init(viewModel: koin.settingsVM())
    }
}

class SwitchEventObservableViewModel: ObservableViewModel<SwitchEventState, SwitchEventEffect, SwitchEventViewModel> {
    init() {
        super.init(viewModel: koin.switchEventVM())
    }
}

class RegisterObservableViewModel: ObservableViewModel<RegisterState, RegisterEffect, RegisterViewModel> {
    init() {
        super.init(viewModel: koin.registerVM())
    }
}
