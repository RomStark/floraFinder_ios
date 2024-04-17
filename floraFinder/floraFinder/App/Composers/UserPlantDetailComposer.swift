//
//  UserPlantDetailComposer.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import FunctionalNavigationFlowKit



protocol UserPlantDetailDependencies: ImageLoadingDependencies  {
        var userService: UserService { get }
}

struct UserPlantDetailFlowDependencies {
    
    
    //    let settings: Flow
}


enum UserPlantDetailComposer {
    static func compose(
        dependencies: UserPlantDetailDependencies,
        flowDependencies: UserPlantDetailFlowDependencies,
        plant: UserPlant
    ) -> UIViewController {
        let viewModel = UserPlantDetailViewModel(plant: plant, service: dependencies.userService, imageLoader: dependencies.imageLoader)
        viewModel.onComplete = {
            switch $0 {
                
                
            }
        }
        
        
        let viewController = UserPlantDetailViewController()
        //        viewController.bind(to: viewModel).dispose()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}

