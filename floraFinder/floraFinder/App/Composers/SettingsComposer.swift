//
//  SettingsComposer.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//


import FunctionalNavigationFlowKit


protocol SettingsDependencies: AuthDependencies {
}

struct SettingsFlowDependencies {
    let logout: Flow
}

enum SettingsComposer {
    static func compose(
        dependencies: SettingsDependencies,
        flowDependencies: SettingsFlowDependencies
    ) -> UIViewController {
        let viewModel = SettingsViewModel()
        viewModel.onComplete = {
            switch $0 {
            case .logOut:
                flowDependencies.logout()
            }
        }
        
        let viewController = SettingsViewController()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel )
        }
        
        return viewController
    }
}

