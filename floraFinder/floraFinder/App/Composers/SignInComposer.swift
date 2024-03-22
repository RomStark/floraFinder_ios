//
//  SignInComposer.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import FunctionalNavigationFlowKit


public protocol AuthDependencies {
    var authService: UserService { get }
}

public struct SignInFlowDependencies {
    let onLogin: Flow
    let changeToLogin: Flow
}

enum SignInComposer {
    static func compose(
        dependencies: AuthDependencies,
        flowDependencies: SignInFlowDependencies
    ) -> UIViewController {
        let viewModel = SignInScreenViewModel(service: dependencies.authService)
        viewModel.onComplete = {
            switch $0 {
            case .login:
                flowDependencies.onLogin()
            case .changeToLogin:
                flowDependencies.changeToLogin()
            }
        }
        
        let viewController = SignInScreenViewController()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel )
        }
        
        return viewController
    }
}
