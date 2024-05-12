/// Base on
/// - https://johnoreilly.dev/posts/kotlinmultiplatform-swift-combine_publisher-flow/
/// - https://proandroiddev.com/kotlin-multiplatform-mobile-sharing-the-ui-state-management-a67bd9a49882
/// - https://github.com/orbit-mvi/orbit-swift-gradle-plugin/blob/main/src/main/resources/stateObject.swift.mustache

import Foundation
import shared

class ObservableViewModel<State: ViewModelState, Effect: ViewModelEffect, ViewModel: AbstractViewModel<State, Effect>>: ObservableObject {
    @Published
    public private(set) var state: State

    public let actual: ViewModel

    private var task: Task<Void, Error>? = nil

    init(viewModel: ViewModel, subscribe _: Bool = true) {
        actual = viewModel
        // This is save, as the constraint is required by the generics (S must be the state of the provided VM)
        state = actual.container.stateFlow.value as! State

        Task {
            await activate()
        }
    }

    @MainActor
    func activate() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let stateFlow = self?.actual.container.stateFlow else { return }

            for await state in stateFlow {
                self?.state = state as! State
            }
        }
    }

    func deactivate() {
        task?.cancel()
        task = nil
    }

    deinit {
        actual.onCleared()

        task?.cancel()
        task = nil
    }
}

class ObservableTableListViewModel: ObservableViewModel<TableListState, TableListEffect, TableListViewModel> {
    init() {
        super.init(viewModel: koin.tableListVM(), subscribe: false)
    }
}

class ObservableTableDetailViewModel: ObservableViewModel<TableDetailState, TableDetailEffect, TableDetailViewModel> {
    init(table: Table) {
        super.init(viewModel: koin.tableDetailVM(table: table), subscribe: false)
    }
}

class ObservableRootViewModel: ObservableViewModel<RootState, RootEffect, RootViewModel> {
    init() {
        super.init(viewModel: koin.rootVM())
    }
}

class ObservableBillingViewModel: ObservableViewModel<BillingState, BillingEffect, BillingViewModel> {
    init(table: Table) {
        super.init(viewModel: koin.billingVM(table: table))
    }
}

class ObservableOrderViewModel: ObservableViewModel<OrderState, OrderEffect, OrderViewModel> {
    init(table: Table, initialItemId: KotlinLong?) {
        super.init(viewModel: koin.orderVM(table: table, initialItemId: initialItemId))
    }
}

class ObservableLoginScannerViewModel: ObservableViewModel<LoginScannerState, LoginScannerEffect, LoginScannerViewModel> {
    init() {
        super.init(viewModel: koin.loginScannerVM())
    }
}

class ObservableSettingsViewModel: ObservableViewModel<SettingsState, SettingsEffect, SettingsViewModel> {
    init() {
        super.init(viewModel: koin.settingsVM())
    }
}

class ObservableSwitchEventViewModel: ObservableViewModel<SwitchEventState, SwitchEventEffect, SwitchEventViewModel> {
    init() {
        super.init(viewModel: koin.switchEventVM())
    }
}

class ObservableRegisterViewModel: ObservableViewModel<RegisterState, RegisterEffect, RegisterViewModel> {
    init() {
        super.init(viewModel: koin.registerVM())
    }
}

class ObservableLoginViewModel: ObservableViewModel<LoginState, LoginEffect, LoginViewModel> {
    init() {
        super.init(viewModel: koin.loginVM())
    }
}
