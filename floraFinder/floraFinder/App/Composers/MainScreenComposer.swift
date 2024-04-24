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
    
    let plantInfoFlow: (UserPlant, @escaping () -> Void) -> ()

    let allPlantFlow: ( @escaping () -> Void) -> ()
    let openCamera: () -> ()
}


enum MainScreensComposer {
    static func compose(
        dependencies: MainScreenDependencies,
        flowDependencies: MainScreenFlowDependencies
    ) -> UIViewController {
        let viewModel = MainScreenViewModel(service: dependencies.mainService, imageLoader: dependencies.imageLoader)
        let viewController = MainScreenViewController()
        
        viewModel.onComplete = {
            switch $0 {
            case .plantInfo(let model, let onDelete):
                flowDependencies.plantInfoFlow(model, onDelete)
            case let .allPlants(onAdd):
                flowDependencies.allPlantFlow(onAdd)
            case let .plantWatering(text):
                viewController.showTopHint(text: text)
            case .diseaseOpen:
                flowDependencies.openCamera()
            }
        }

        
       
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}
