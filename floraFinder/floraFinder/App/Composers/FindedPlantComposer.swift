//
//  FindedPlantComposer.swift
//  floraFinder
//
//  Created by Al Stark on 17.04.2024.
//

import FunctionalNavigationFlowKit

protocol FindedPlantDependencies: ImageLoadingDependencies  {
//    var mainService: MainService { get }
    var userService: UserService { get }
    
}

struct FindedPlantFlowDependencies {
    
//    let plantInfoFlow: (Plant) -> ()
////
////    let allPlantFlow: Flow
//    let openCamera: () -> ()
}


enum FindedPlantComposer {
    static func compose(
        dependencies: FindedPlantDependencies,
        flowDependencies: FindedPlantFlowDependencies,
        name: String
    ) -> UIViewController {
        let viewModel = FindedPlantInfoViewModel(name: name, service: dependencies.userService, imageLoader: dependencies.imageLoader)
        viewModel.onComplete = {
            switch $0 {
            
//            case let .plantInfo(model):
//                flowDependencies.plantInfoFlow(model)
//            case .allPlants:
//                flowDependencies.allPlantFlow()
            
            }
        }

        
        let viewController = FindedPlantInfoViewController()
//        viewController.bind(to: viewModel).dispose()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}
