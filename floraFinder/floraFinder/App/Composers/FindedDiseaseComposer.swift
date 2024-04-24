//
//  FindedDiseaseComposer.swift
//  floraFinder
//
//  Created by Al Stark on 24.04.2024.
//

import FunctionalNavigationFlowKit

protocol FindedDiseaseDependencies: ImageLoadingDependencies  {
    var userService: UserService { get }
    
}

struct FindedDiseaseFlowDependencies {
    
//    let plantInfoFlow: (Plant) -> ()
////
////    let allPlantFlow: Flow
//    let openCamera: () -> ()
}


enum FindedDiseaseComposer {
    static func compose(
        dependencies: FindedDiseaseDependencies,
        flowDependencies: FindedDiseaseFlowDependencies,
        name: String
    ) -> UIViewController {
        let viewModel = DiseaseInfoViewModel(name: name, service: dependencies.userService, imageLoader: dependencies.imageLoader)
        viewModel.onComplete = {
            switch $0 {
            
//            case let .plantInfo(model):
//                flowDependencies.plantInfoFlow(model)
//            case .allPlants:
//                flowDependencies.allPlantFlow()
            
            }
        }

        
        let viewController = DiseaseInfoViewController()
//        viewController.bind(to: viewModel).dispose()
        viewController.subscription = LifetimeSubscription { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}
