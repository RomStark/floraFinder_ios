//
//  MainScreenComposer.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import FunctionalNavigationFlowKit

protocol MainScreenDependencies: ImageLoadingDependencies, UserPlantDetailDependencies, AllPlantsDependencies {
    var mainService: MainService { get }
}

struct MainScreenFlowDependencies {
    
    let plantInfoFlow: (UserPlant) -> ()

    let allPlantFlow: ( @escaping () -> Void) -> ()
}


enum MainScreensComposer {
    static func compose(
        dependencies: MainScreenDependencies,
        flowDependencies: MainScreenFlowDependencies
    ) -> UIViewController {
        let viewModel = MainScreenViewModel(service: dependencies.mainService, imageLoader: dependencies.imageLoader)
        viewModel.onComplete = {
            switch $0 {
            case let .plantInfo(model):
                flowDependencies.plantInfoFlow(model)
            case let .allPlants(onAdd):
                flowDependencies.allPlantFlow(onAdd)
            }
        }

        
        let viewController = MainScreenViewController()
//        viewController.bind(to: viewModel).dispose()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}
