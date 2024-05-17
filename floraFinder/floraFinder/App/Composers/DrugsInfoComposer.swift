//
//  DrugsInfoComposer.swift
//  floraFinder
//
//  Created by Al Stark on 16.05.2024.
//

import FunctionalNavigationFlowKit


struct DrugsInfoFlowDependencies {
}


enum DrugsInfoComposer {
    static func compose(
        dependencies: UserDrugsDependencies,
        flowDependencies: DrugsInfoFlowDependencies,
        drug: Drugs
    ) -> UIViewController {
        let viewModel = DrugsInfoViewModel(drug: drug, service: dependencies.userService, imageLoader: dependencies.imageLoader)
        
        let viewController = DrugsInfoViewController()
        
        viewModel.onComplete = {
            switch $0 {
            
            }
        }
        
        
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}

