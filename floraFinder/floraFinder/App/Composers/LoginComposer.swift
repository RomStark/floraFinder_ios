//
//  LoginComposer.swift
//  floraFinder
//
//  Created by Al Stark on 22.03.2024.
//

import FunctionalNavigationFlowKit



public struct LoginFlowDependencies {
    let onLogin: Flow
    let changeToSignIn: Flow
}

enum LoginComposer {
    static func compose(
        dependencies: AuthDependencies,
        flowDependencies: LoginFlowDependencies
    ) -> UIViewController {
        let viewModel = LoginScreenViewModel(service: dependencies.authService)
        viewModel.onComplete = {
            switch $0 {
            case .login:
                flowDependencies.onLogin()
            case .changeToSignIn:
                flowDependencies.changeToSignIn()
            }
        }
        
        let viewController = LoginScreenViewController()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel )
        }
        
        return viewController
    }
}
