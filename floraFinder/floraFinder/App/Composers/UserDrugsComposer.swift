//
//  UserDrugsComposer.swift
//  floraFinder
//
//  Created by Al Stark on 16.05.2024.
//


import FunctionalNavigationFlowKit

protocol UserDrugsDependencies: ImageLoadingDependencies, CameraDependencies  {
    var mainService: MainService { get }
    var userService: UserService { get }
}

struct UserDrugsFlowDependencies {
    
    let drugInfoFlow: (Drugs) -> ()

}


enum UserDrugsComposer {
    static func compose(
        dependencies: UserDrugsDependencies,
        flowDependencies: UserDrugsFlowDependencies
    ) -> UIViewController {
        let viewModel = DrugsListViewModel(service: dependencies.mainService, imageLoader: dependencies.imageLoader)
        viewModel.onComplete = {
            switch $0 {
            case let .drugInfo(drug):
                flowDependencies.drugInfoFlow(drug)
            }
        }

        
        let viewController = DrugsListViewController()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}
