//
//  AllPlantsComposer.swift
//  floraFinder
//
//  Created by Al Stark on 22.03.2024.
//

import FunctionalNavigationFlowKit

protocol AllPlantsDependencies: ImageLoadingDependencies, CameraDependencies  {
    var mainService: MainService { get }
    var userService: UserService { get }
}

struct AllPlantsFlowDependencies {
    
    let plantInfoFlow: (Plant) -> ()
//
//    let allPlantFlow: Flow
    let openCamera: () -> ()
}


enum AllPlantsComposer {
    static func compose(
        dependencies: AllPlantsDependencies,
        flowDependencies: AllPlantsFlowDependencies
    ) -> UIViewController {
        let viewModel = PlantsListViewModel(service: dependencies.mainService, imageLoader: dependencies.imageLoader)
        viewModel.onComplete = {
            switch $0 {
            case let .plantInfo(plant):
                flowDependencies.plantInfoFlow(plant)
            case .openCamera:
                flowDependencies.openCamera()
//            case let .plantInfo(model):
//                flowDependencies.plantInfoFlow(model)
//            case .allPlants:
//                flowDependencies.allPlantFlow()
            }
        }

        
        let viewController = PlantsListViewController()
//        viewController.bind(to: viewModel).dispose()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}
