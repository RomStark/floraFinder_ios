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
        plant: UserPlant,
        onDelete: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = UserPlantDetailViewModel(plant: plant, service: dependencies.userService, imageLoader: dependencies.imageLoader, onDelete: onDelete)
        let viewController = UserPlantDetailViewController()
        viewModel.onComplete = {
            switch $0 {
                
            case .deletePlant(let text):
                viewController.showTopHint(text: text)
            }
        }
        
        
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}

