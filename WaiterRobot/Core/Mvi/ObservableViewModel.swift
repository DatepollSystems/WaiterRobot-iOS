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

    init(viewModel: ViewModel) {
        actual = viewModel
        // This is save, as the constraint is required by the generics (S must be the state of the provided VM)
        state = actual.container.stateFlow.value as! State
    }

    @MainActor
    func activate() async {
        for await state in actual.container.refCountStateFlow {
            self.state = state as! State
        }
    }

    deinit {
        actual.onCleared()
    }
}

class ObservableTableListViewModel: ObservableViewModel<TableListState, TableListEffect, TableListViewModel> {
    init() {
        super.init(viewModel: koin.tableListVM())
    }
}

class ObservableTableDetailViewModel: ObservableViewModel<TableDetailState, TableDetailEffect, TableDetailViewModel> {
    init(table: Table) {
        super.init(viewModel: koin.tableDetailVM(table: table))
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
